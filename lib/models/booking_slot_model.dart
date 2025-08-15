// booking_models.dart
class BranchAvailability {
  final int branchId;
  final String branchName;
  final List<AvailableDate> availableDates;

  BranchAvailability({
    required this.branchId,
    required this.branchName,
    required this.availableDates,
  });

  factory BranchAvailability.fromJson(Map<String, dynamic> json) {
    return BranchAvailability(
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      availableDates: (json['available_dates'] as List)
          .map((dateJson) => AvailableDate.fromJson(dateJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'branch_name': branchName,
      'available_dates': availableDates.map((e) => e.toJson()).toList(),
    };
  }
}

class AvailableDate {
  final String date;
  final List<Slot> slots;

  AvailableDate({
    required this.date,
    required this.slots,
  });

  factory AvailableDate.fromJson(Map<String, dynamic> json) {
    return AvailableDate(
      date: json['date'],
      slots: (json['slots'] as List)
          .map((slotJson) => Slot.fromJson(slotJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'slots': slots.map((e) => e.toJson()).toList(),
    };
  }
}

class Slot {
  final String time;
  final String status; // "available" or "booked"

  Slot({
    required this.time,
    required this.status,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'status': status,
    };
  }
}
