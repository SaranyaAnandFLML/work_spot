// notification_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/notification_service.dart';
import '../../../models/notification_model.dart';
import '../repository/notifications_repository.dart';


final notificationControllerProvider = StateNotifierProvider<NotificationController, AsyncValue<void>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  final notificationService = NotificationService();
  return NotificationController(repo, notificationService);
});

final listNotificationsProvider = FutureProvider<List<NotificationModel>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.listNotification();  // Just fetch data, no state mutations
});

class NotificationController extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository repository;
  final NotificationService notificationService;

  NotificationController(this.repository, this.notificationService)
      : super(const AsyncValue.data(null));

  Future<void> addNotification(NotificationModel notification) async {
    state = const AsyncValue.loading();
    try {
      await repository.saveNotification(notification);
      notificationService.showNotification(notification);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }


  Future<List<NotificationModel>> listNotification({bool setLoading = true}) async {
    state = const AsyncValue.loading();
    try {
      final bookings = await repository.listNotification();
      state = const AsyncValue.data(null);
      return bookings;
    } catch (e,st) {
      state = AsyncValue.error(e, st);
      throw e;
    }
  }

}


