import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../../core/global/variables.dart';
import '../../../models/notification_model.dart';
import '../../../theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/notifications_controller.dart';

class Notifications extends ConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(listNotificationsProvider);

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
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'NO DATA FOUND',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: w * 0.05,
                  color: Colors.grey,
                ),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(w * 0.06, w * 0.03, w * 0.06, w * 0.06),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

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
                            fontSize: w * 0.045,
                          ),
                        ),
                        Text(
                          notification.message,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: w * 0.03,
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
