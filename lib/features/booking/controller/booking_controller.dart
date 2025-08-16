import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_slot_model.dart';
import '../../../models/notification_model.dart';
import '../../notification/controller/notifications_controller.dart';
import '../repository/booking_repository.dart';

final bookingControllerProvider = ChangeNotifierProvider<BookingController>((ref) {
  return BookingController();
});

final myBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final bookingController = ref.read(bookingControllerProvider);
  return bookingController.loadBookings(setLoading: false);
});

class BookingController extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  bool isLoading = false;
  List<BranchAvailability> branches = [];
  List<String> availableDates = [];
  List<Slot> slots = [];

  int? selectedBranchId;
  DateTime? selectedDate;

  /// Load all branches and availability
  Future<void> loadAllBranches() async {
    _setLoading(true);
    try {
      branches = await _repository.getAllData();
    } catch (e) {
      debugPrint("Error loading branches: $e");
    }
    _setLoading(false);
  }

  /// Load dates for a specific branch
  Future<void> loadDatesForBranch(int branchId) async {
    _setLoading(true);
    try {
      selectedBranchId = branchId;
      availableDates = await _repository.getDatesForBranch(branchId);
    } catch (e) {
      debugPrint("Error loading dates: $e");
    }
    _setLoading(false);
  }

  /// Load slots for a specific date (requires branch to be set)
  Future<void> loadSlotsForDate(String date) async {
    if (selectedBranchId == null) {
      debugPrint("Branch not selected!");
      return;
    }
    _setLoading(true);
    try {
      selectedDate = DateTime.parse(date);
      slots = await _repository.getSlotsForDate(selectedBranchId!, date);
    } catch (e) {
      debugPrint("Error loading slots: $e");
    }
    _setLoading(false);
  }

  /// Helper to set loading state
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }



  Future<void> saveBooking({
    required String bookingSlot,
    required DateTime bookingDate,
    required String workspaceName,
    required String city,
    required String branch,
    required String location,
    required double pricePerHour,
    required String userId,
    required WidgetRef ref,
    required NotificationModel notification
  }) async {
    _setLoading(true);
    try {
      await _repository.saveBooking(
        bookingSlot: bookingSlot,
        bookingDate: bookingDate,
        workspaceName: workspaceName,
        city: city,
        branch: branch,
        location: location,
        pricePerHour: pricePerHour,
        userId: userId,
      );

      final notificationController = ref.watch(notificationControllerProvider.notifier);
      await notificationController.addNotification(notification);
      ref.refresh(myBookingsProvider);
      _setLoading(false);
    } catch (e, st) {
     throw e;
    }
  }


  Future<List<Booking>> loadBookings({bool setLoading = true}) async {
    if (setLoading) _setLoading(true);
    try {
      final bookings = await _repository.listBookings();
      if (setLoading) _setLoading(false);
      return bookings;
    } catch (e) {
      if (setLoading) _setLoading(false);
      throw e;
    }
  }


  Future<void> deleteBooking(int bookingKey, NotificationModel notification, WidgetRef ref) async {
    await _repository.deleteBooking(bookingKey);
    final notificationController = ref.watch(notificationControllerProvider.notifier);
    await notificationController.addNotification(notification);

    // Refresh the bookings provider to reload updated data
    ref.refresh(myBookingsProvider);
  }


}
