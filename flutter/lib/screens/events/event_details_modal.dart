import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/event_model.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class EventDetailsModal extends StatelessWidget {
  final Event event;

  const EventDetailsModal({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isOrganizer = event.organizer == authProvider.currentUser?.username;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_today,
                  'Date: ${DateFormat('MMM dd, yyyy').format(event.date)}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, 'Location: ${event.location}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person, 'Organizer: ${event.organizer}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.category,
                  'Category: ${event.category[0].toUpperCase()}${event.category.substring(1)}'),
              if (event.maxParticipants != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(Icons.group,
                    'Max Participants: ${event.maxParticipants}'),
              ],
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (isOrganizer || authProvider.isAdmin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                      child: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        // TODO: Implement delete functionality
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}