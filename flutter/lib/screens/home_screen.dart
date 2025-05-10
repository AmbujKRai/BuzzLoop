import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/role_based_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Discovery'),
        actions: [
          RoleBasedWidget(
            allowedRoles: ['admin'],
            showReplacement: false,
            child: IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Admin Panel',
              onPressed: () {
                Navigator.of(context).pushNamed('/admin');
              },
            ),
          ),

          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authProvider.logout().then((_) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
            },
          ),
        ],
      ),

      floatingActionButton: RoleBasedWidget(
        allowedRoles: ['organizer', 'admin'],
        showReplacement: false,
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: 'Create Event',
          onPressed: () {
            Navigator.of(context).pushNamed('/events/create');
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.username ?? 'Guest'}!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Account type: ${user?.role != null ? user!.role.substring(0, 1).toUpperCase() + user.role.substring(1) : 'Guest'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Discover Events',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),

            _buildRoleSpecificActions(context),

            const SizedBox(height: 16),

            Expanded(
              child: Center(
                child: Text(
                  'Events will be displayed here',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSpecificActions(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (authProvider.isAuthenticated)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('My Registered Events'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).pushNamed('/events/registered');
                  },
                ),
              ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text('Manage My Events'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).pushNamed('/events/manage');
                },
              ),
            ).organizerOnly(context,
              unauthorizedChild: const SizedBox.shrink(),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people_alt),
                title: const Text('Manage Users'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).pushNamed('/admin/users');
                },
              ),
            ).adminOnly(context),
          ],
        );
      },
    );
  }
}