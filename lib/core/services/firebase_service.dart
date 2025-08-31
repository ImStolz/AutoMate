// import 'dart:typed_data';  // Temporarily unused
// import 'package:flutter/foundation.dart';  // Temporarily unused
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';  // Temporarily disabled for web
import 'package:google_sign_in/google_sign_in.dart';
import '../../firebase_options.dart';

/// Servicio principal de Firebase que maneja la configuración
/// y proporciona acceso a los servicios de Firebase
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();

  /// Instancia de Firebase Auth
  FirebaseAuth get auth => FirebaseAuth.instance;
  
  /// Instancia de Firestore
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  
  // Firebase Storage temporalmente deshabilitado para compatibilidad web
  // FirebaseStorage? get storage => kIsWeb ? null : FirebaseStorage.instance;
  
  /// Instancia de Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Inicializa Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Configurar Firestore para modo offline
      try {
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
      } catch (e) {
        // Ignorar errores de configuración de Firestore si ya está configurado
        print('Firestore settings already configured: $e');
      }
    } on FirebaseException catch (e) {
      // Si Firebase ya está inicializado, continuar silenciosamente
      if (e.code == 'duplicate-app') {
        print('Firebase already initialized');
        return;
      }
      print('Firebase initialization error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }

  /// Obtiene el usuario actual
  User? get currentUser => auth.currentUser;

  /// Stream del estado de autenticación
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Registra un nuevo usuario con email y contraseña
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar el perfil del usuario
      await credential.user?.updateDisplayName(displayName);
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Inicia sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Inicia sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  /// Envía email de restablecimiento de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Cierra sesión
  Future<void> signOut() async {
    try {
      await Future.wait([
        auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  /// Elimina la cuenta del usuario
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Maneja las excepciones de Firebase Auth
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('La contraseña es muy débil');
      case 'email-already-in-use':
        return Exception('Ya existe una cuenta con este email');
      case 'user-not-found':
        return Exception('No se encontró usuario con este email');
      case 'wrong-password':
        return Exception('Contraseña incorrecta');
      case 'invalid-email':
        return Exception('Email inválido');
      case 'user-disabled':
        return Exception('Esta cuenta ha sido deshabilitada');
      case 'too-many-requests':
        return Exception('Demasiados intentos. Intenta más tarde');
      case 'operation-not-allowed':
        return Exception('Operación no permitida');
      default:
        return Exception('Error de autenticación: ${e.message}');
    }
  }

  /// Obtiene una referencia a la colección de usuarios
  CollectionReference get usersCollection => 
      firestore.collection('users');

  /// Obtiene una referencia a la colección de vehículos
  CollectionReference get vehiclesCollection => 
      firestore.collection('vehicles');

  /// Obtiene una referencia a la colección de gastos
  CollectionReference get expensesCollection => 
      firestore.collection('expenses');

  /// Obtiene una referencia a la colección de mantenimientos
  CollectionReference get maintenanceCollection => 
      firestore.collection('maintenance');

  // Métodos de Firebase Storage temporalmente deshabilitados para compatibilidad web
  /*
  /// Sube una imagen a Firebase Storage (solo disponible en móviles)
  Future<String> uploadImage({
    required String path,
    required String fileName,
    required List<int> imageBytes,
  }) async {
    if (kIsWeb) {
      throw Exception('Image upload not available on web platform');
    }
    
    try {
      final ref = storage!.ref().child('$path/$fileName');
      final uploadTask = ref.putData(
        Uint8List.fromList(imageBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// Elimina una imagen de Firebase Storage (solo disponible en móviles)
  Future<void> deleteImage(String imageUrl) async {
    if (kIsWeb) {
      throw Exception('Image deletion not available on web platform');
    }
    
    try {
      final ref = storage!.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }
  */
}
