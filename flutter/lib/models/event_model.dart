class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String organizer;
  final int? maxParticipants;
  final List<String> participants;
  final String category;
  final String status;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.organizer,
    this.maxParticipants,
    required this.participants,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: DateTime.parse(json['date']),
      organizer: json['organizer']['username'] ?? '',
      maxParticipants: json['maxParticipants'],
      participants: List<String>.from(json['participants']?.map((p) => p['username']) ?? []),
      category: json['category'] ?? 'other',
      status: json['status'] ?? 'upcoming',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'maxParticipants': maxParticipants,
      'category': category,
    };
  }
}