import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RouteGuard {
  static bool isAuthenticated(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isAuthenticated;
  }

  static bool hasRole(BuildContext context, String role) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.hasPermission(role);
  }

  static void redirectToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  static void handleUnauthorized(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You don\'t have permission to access this page'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.of(context).pop();
  }
}

class AuthGuard extends StatelessWidget {
  final Widget child;
  final String? redirectRoute;

  const AuthGuard({
    Key? key,
    required this.child,
    this.redirectRoute = '/login',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(redirectRoute!);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return child;
  }
}

class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;
  final String? redirectRoute;

  const RoleGuard({
    Key? key,
    required this.child,
    required this.allowedRoles,
    this.redirectRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final hasAccess = allowedRoles.contains(authProvider.currentUser!.role);
    if (!hasAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (redirectRoute != null) {
          Navigator.of(context).pushReplacementNamed(redirectRoute!);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You don\'t have permission to access this page'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return child;
  }
}