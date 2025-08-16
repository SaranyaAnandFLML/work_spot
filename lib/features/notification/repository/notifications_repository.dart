import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../../models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

class NotificationRepository {
  Future<void> saveNotification(NotificationModel notification) async {
    final box = await Hive.openBox<NotificationModel>('notifications');
    await box.add(notification);
  }

  Future<List<NotificationModel>> listNotification() async {
    final box = await Hive.openBox<NotificationModel>('notifications');
    return box.values.toList();
  }
}
