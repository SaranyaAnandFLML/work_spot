import 'package:hive_ce_flutter/adapters.dart';


class Booking extends HiveObject {
  DateTime bookingTime;
  String bookingSlot;
  DateTime bookingDate;
  String userId;
  String workspaceName;
  String city;
  String branch;
  String location;
  double pricePerHour;

  Booking({
    required this.bookingTime,
    required this.bookingSlot,
    required this.bookingDate,
    required this.userId,
    required this.workspaceName,
    required this.city,
    required this.branch,
    required this.location,
    required this.pricePerHour,
  });
}


class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 0; // Unique id for this adapter

  @override
  Booking read(BinaryReader reader) {
    return Booking(
      bookingTime: reader.read(),
      bookingSlot: reader.read(),
      bookingDate: reader.read(),
      userId: reader.read(),
      workspaceName: reader.read(),
      city: reader.read(),
      branch: reader.read(),
      location: reader.read(),
      pricePerHour: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..write(obj.bookingTime)
      ..write(obj.bookingSlot)
      ..write(obj.bookingDate)
      ..write(obj.userId)
      ..write(obj.workspaceName)
      ..write(obj.city)
      ..write(obj.branch)
      ..write(obj.location)
      ..write(obj.pricePerHour);
  }
}
