import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';
import 'create_event_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventScreen()),
          );
          if (result == true) {
            _refreshEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Event>>(
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
              child: Text('No events found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refreshEvents(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
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
                      // TODO: Navigate to event details screen
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}