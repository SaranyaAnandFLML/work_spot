import 'package:hive_ce_flutter/adapters.dart';

class NotificationModel {
  String title;
  String message;

  NotificationModel({
    required this.title,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    title: json["title"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "message": message,
  };
}



class NotificationAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 1; // Unique id for this adapter

  @override
  NotificationModel read(BinaryReader reader) {
    return NotificationModel(
      message: reader.read(),
      title: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..write(obj.message)
      ..write(obj.title);
  }
}
