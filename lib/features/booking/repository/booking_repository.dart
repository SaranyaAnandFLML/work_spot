import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../models/booking_slot_model.dart';

class BookingRepository {
  final String jsonPath = 'assets/json_files/booking_slot.json';

  /// Load & parse full branch availability data
  Future<List<BranchAvailability>> getAllData() async {
    final String jsonString = await rootBundle.loadString(jsonPath);
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => BranchAvailability.fromJson(json)).toList();
  }

  /// Get all dates for a specific branch
  Future<List<String>> getDatesForBranch(int branchId) async {
    final branches = await getAllData();
    final branch = branches.firstWhere(
          (b) => b.branchId == branchId,
      orElse: () => throw Exception('Branch not found'),
    );
    return branch.availableDates.map((dateObj) => dateObj.date).toList();
  }

  /// Get all unique dates across all branches
  Future<List<String>> getAllUniqueDates() async {
    final branches = await getAllData();
    final allDates = branches
        .expand((b) => b.availableDates.map((d) => d.date))
        .toSet()
        .toList();
    allDates.sort();
    return allDates;
  }

  /// Get slots for a specific branch and date
  Future<List<Slot>> getSlotsForDate(int branchId, String date) async {
    final branches = await getAllData();
    final branch = branches.firstWhere(
          (b) => b.branchId == branchId,
      orElse: () => throw Exception('Branch not found'),
    );

    final availableDate = branch.availableDates.firstWhere(
          (d) => d.date == date,
      orElse: () => throw Exception('No slots found for this date'),
    );

    return availableDate.slots; // List<Slot>
  }
}
