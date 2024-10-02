import 'package:flutter/foundation.dart';
import 'package:labaneta_sweet/models/notification.dart';

class NotificationProvider with ChangeNotifier {
  final List<AppNotification> _notifications = [
    // Add some dummy notifications for testing
    AppNotification(
      id: '1',
      title: 'Your order is on the way',
      body: 'Your delicious treats will be delivered soon!',
      type: NotificationType.order,
    ),
    AppNotification(
      id: '2',
      title: 'New promotion available',
      body: 'Get 20% off on all cakes this weekend!',
      type: NotificationType.promotion,
    ),
    AppNotification(
      id: '3',
      title: 'Thank you for your purchase',
      body: 'We hope you enjoy your sweet treats!',
      type: NotificationType.general,
    ),
  ];

  List<AppNotification> get notifications => [..._notifications];

  void addNotification(AppNotification notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void removeNotification(AppNotification notification) {
    _notifications.remove(notification);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}