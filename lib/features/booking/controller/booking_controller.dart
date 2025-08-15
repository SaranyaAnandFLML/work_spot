import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/booking_slot_model.dart';
import '../repository/booking_repository.dart';

final bookingControllerProvider = ChangeNotifierProvider<BookingController>((ref) {
  return BookingController();
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
}
