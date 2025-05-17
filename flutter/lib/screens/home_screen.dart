import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/role_based_widget.dart';
import '../services/event_service.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';
import 'events/create_event_screen.dart';
import 'events/event_details_modal.dart';
import 'admin/admin_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = EventService.getAllEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = EventService.getAllEvents();
    });
  }

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminScreen(),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
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
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateEventScreen()),
            );
            if (result == true) {
              _refreshEvents();
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshEvents(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 24),
            Text(
              'Upcoming Events',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Event>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final events = snapshot.data ?? [];
                if (events.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No events found'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          event.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('📍 ${event.location}'),
                            Text(
                              '📅 ${DateFormat('MMM dd, yyyy').format(event.date)}',
                            ),
                            Text('👤 Organized by ${event.organizer}'),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            event.category.toUpperCase(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => EventDetailsModal(event: event),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}