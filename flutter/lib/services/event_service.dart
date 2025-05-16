import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/event_model.dart';
import '../utils/secure_storage.dart';

class EventService {
  static Future<List<Event>> getAllEvents() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.events}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  static Future<Event> createEvent(Map<String, dynamic> eventData) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) throw Exception('No authentication token');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.events}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Event.fromJson(data['event']);
      } else {
        throw Exception('Failed to create event');
      }
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }
}