import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../../core/global/variables.dart';
import '../../../models/notification_model.dart';
import '../../../theme/pallete.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Box<NotificationModel> notificationBox;
  @override
  void initState() {
    super.initState();
    notificationBox = Hive.box<NotificationModel>('notifications');
  }

  @override
  Widget build(BuildContext context) {
    final allNotifications = notificationBox.toMap().entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: w * 0.04,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: allNotifications.isEmpty
          ? Center(
        child: Text(
          'NO DATA FOUND',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: w * 0.05,
              color: Colors.grey),
        ),
      )
          : Padding(
        padding: EdgeInsets.fromLTRB(w * 0.06, w * 0.03, w * 0.06, w * 0.06),
        child: ListView.builder(
          itemCount: allNotifications.length,
          itemBuilder: (context, index) {
            final entry = allNotifications[index];
            final notification = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Palette.blackColor.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.045),
                    ),
                    Text(
                      notification.message,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: w * 0.03),
                    ),

                    SizedBox(width: w * 0.02),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
