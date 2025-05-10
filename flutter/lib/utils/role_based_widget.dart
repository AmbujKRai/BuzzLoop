import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RoleBasedWidget extends StatelessWidget {
  final Widget child;

  final Widget? unauthorizedChild;

  final List<String> allowedRoles;

  final bool showReplacement;

  const RoleBasedWidget({
    Key? key,
    required this.child,
    required this.allowedRoles,
    this.unauthorizedChild,
    this.showReplacement = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final hasPermission = authProvider.isAuthenticated &&
            allowedRoles.contains(authProvider.currentUser!.role);

        if (hasPermission) {
          return child;
        } else if (showReplacement && unauthorizedChild != null) {
          return unauthorizedChild!;
        } else if (showReplacement) {
          return Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const Text(
              'You don\'t have permission to access this content',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

extension RoleBasedExtension on Widget {
  Widget withRole(
      BuildContext context, {
        required List<String> roles,
        Widget? unauthorizedChild,
        bool showReplacement = true,
      }) {
    return RoleBasedWidget(
      allowedRoles: roles,
      unauthorizedChild: unauthorizedChild,
      showReplacement: showReplacement,
      child: this,
    );
  }

  Widget adminOnly(BuildContext context, {Widget? unauthorizedChild}) {
    return withRole(
      context,
      roles: ['admin'],
      unauthorizedChild: unauthorizedChild,
    );
  }

  Widget organizerOnly(BuildContext context, {Widget? unauthorizedChild}) {
    return withRole(
      context,
      roles: ['organizer', 'admin'],
      unauthorizedChild: unauthorizedChild,
    );
  }
}