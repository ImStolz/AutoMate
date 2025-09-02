import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/vehicles/screens/vehicles_screen.dart';
import '../../features/expenses/screens/expenses_screen.dart';
import '../../features/maintenance/screens/maintenance_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/premium/screens/premium_screen.dart';
import '../../features/legal/screens/terms_of_service_screen.dart';
import '../../features/legal/screens/privacy_policy_screen.dart';
import '../../features/fuel/screens/add_fuel_screen.dart';
import '../providers/auth_provider.dart';
import '../services/preferences_service.dart';
import '../widgets/main_navigation_wrapper.dart';

/// Determina la ubicación inicial basada en el estado de autenticación
String _getInitialLocation(bool isAuthenticated) {
  if (!isAuthenticated) {
    if (PreferencesService.isFirstLaunch() && !PreferencesService.getOnboardingCompleted()) {
      return '/onboarding';
    }
    return '/login';
  }
  return '/dashboard';
}

/// Configuración del router de la aplicación
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: _getInitialLocation(authState.isAuthenticated),
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final currentPath = state.uri.toString();
      final isAuthRoute = currentPath.startsWith('/login') || 
                         currentPath.startsWith('/register') ||
                         currentPath.startsWith('/forgot-password');
      final isOnboardingRoute = currentPath.startsWith('/onboarding');
      
      // Verificar si es primera vez y no está autenticado
      if (!isAuthenticated && !isAuthRoute && !isOnboardingRoute) {
        if (PreferencesService.isFirstLaunch() && !PreferencesService.getOnboardingCompleted()) {
          return '/onboarding';
        }
        return '/login';
      }
      
      // Si está autenticado y está en una ruta de auth o onboarding, redirigir a dashboard
      if (isAuthenticated && (isAuthRoute || isOnboardingRoute)) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      // Ruta de onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Rutas de autenticación
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Rutas principales de la aplicación
      ShellRoute(
        builder: (context, state, child) => MainNavigationWrapper(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/vehicles',
            name: 'vehicles',
            builder: (context, state) => const VehiclesScreen(),
          ),
          GoRoute(
            path: '/expenses',
            name: 'expenses',
            builder: (context, state) => const ExpensesScreen(),
          ),
          GoRoute(
            path: '/maintenance',
            name: 'maintenance',
            builder: (context, state) => const MaintenanceScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Rutas adicionales
      GoRoute(
        path: '/premium',
        name: 'premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/add-fuel',
        name: 'add-fuel',
        builder: (context, state) => const AddFuelScreen(),
      ),
    ],
  );
});

/// Wrapper para la navegación principal con bottom navigation bar
class MainNavigationWrapper extends StatefulWidget {
  final Widget child;
  
  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    NavigationItem(
      icon: Icons.directions_car_outlined,
      selectedIcon: Icons.directions_car,
      label: 'Vehículos',
      route: '/vehicles',
    ),
    NavigationItem(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: 'Gastos',
      route: '/expenses',
    ),
    NavigationItem(
      icon: Icons.build_outlined,
      selectedIcon: Icons.build,
      label: 'Mantenimiento',
      route: '/maintenance',
    ),
    NavigationItem(
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
      label: 'Perfil',
      route: '/profile',
    ),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      context.go(_navigationItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Actualizar el índice seleccionado basado en la ruta actual
    final currentRoute = GoRouterState.of(context).uri.toString();
    final currentIndex = _navigationItems.indexWhere(
      (item) => item.route == currentRoute,
    );
    if (currentIndex != -1 && currentIndex != _selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedIndex = currentIndex;
        });
      });
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _navigationItems.map((item) {
          final isSelected = _navigationItems.indexOf(item) == _selectedIndex;
          return BottomNavigationBarItem(
            icon: Icon(isSelected ? item.selectedIcon : item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

/// Clase para representar un elemento de navegación
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
