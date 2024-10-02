enum NotificationType {
  order,
  promotion,
  general,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  // Add more fields as needed (e.g., timestamp, image URL, etc.)

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
  });
}