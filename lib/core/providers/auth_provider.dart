import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

/// Estado de autenticación
class AuthState {
  final User? firebaseUser;
  final UserModel? userModel;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.firebaseUser,
    this.userModel,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? firebaseUser,
    UserModel? userModel,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => firebaseUser != null;
}

/// Notificador de autenticación que maneja el estado del usuario
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseService _firebaseService;

  AuthNotifier(this._firebaseService) : super(const AuthState()) {
    // Escuchar cambios en el estado de autenticación con manejo de errores
    try {
      _firebaseService.authStateChanges.listen((user) {
        if (user != null) {
          _loadUserModel(user);
        } else {
          state = const AuthState();
        }
      }, onError: (error) {
        print('Auth state changes error: $error');
        state = state.copyWith(error: 'Authentication service unavailable');
      });
    } catch (e) {
      print('Failed to initialize auth listener: $e');
      state = state.copyWith(error: 'Authentication service unavailable');
    }
  }

  /// Carga el modelo de usuario desde Firestore
  Future<void> _loadUserModel(User firebaseUser) async {
    try {
      state = state.copyWith(firebaseUser: firebaseUser, isLoading: true);
      
      final doc = await _firebaseService.usersCollection
          .doc(firebaseUser.uid)
          .get();
      
      UserModel userModel;
      if (doc.exists) {
        userModel = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        // Crear nuevo usuario en Firestore
        userModel = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          photoUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _firebaseService.usersCollection
            .doc(firebaseUser.uid)
            .set(userModel.toJson());
      }
      
      state = state.copyWith(
        firebaseUser: firebaseUser,
        userModel: userModel,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error loading user data: $e',
      );
    }
  }

  /// Registra un nuevo usuario
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _firebaseService.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Inicia sesión con email y contraseña
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Inicia sesión con Google
  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _firebaseService.signInWithGoogle();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Envía email de restablecimiento de contraseña
  Future<void> resetPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _firebaseService.sendPasswordResetEmail(email);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Cierra sesión
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Actualiza el perfil del usuario
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _firebaseService.usersCollection
          .doc(updatedUser.id)
          .update(updatedUser.copyWith(updatedAt: DateTime.now()).toJson());
      
      state = state.copyWith(
        userModel: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error updating profile: $e',
      );
    }
  }

  /// Limpia errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider del servicio Firebase
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

/// Provider del notificador de autenticación
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  return AuthNotifier(firebaseService);
});

/// Provider del usuario actual
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authNotifierProvider).userModel;
});

/// Provider que verifica si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});
