import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../../core/common/notification_service.dart';
import '../../../core/global/variables.dart';
import '../../../models/booking_model.dart';
import '../../../models/notification_model.dart';
import '../../../theme/pallete.dart';

class MyBookings extends StatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<MyBookings> {
  late Box<Booking> bookingBox;
  late Box<NotificationModel> notificationBox;

  @override
  void initState() {
    super.initState();
    bookingBox = Hive.box<Booking>('bookings');
    notificationBox = Hive.box<NotificationModel>('notifications');
  }

  Future<void> _deleteBooking(int key,String workSpaceName) async {
    await bookingBox.delete(key);
    final notification = NotificationModel(
      title: "Booking deleted!",
      message: "your booking for $workSpaceName has been deleted",
    );
    await notificationBox.add(notification);
    final notificationService = NotificationService();
    notificationService.showNotification(notification);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking deleted')),
    );
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    final allBookings = bookingBox.toMap().entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Bookings",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: w * 0.045,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: allBookings.isEmpty
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
          itemCount: allBookings.length,
          itemBuilder: (context, index) {
            final entry = allBookings[index];
            final key = entry.key as int;
            final booking = entry.value;
            DateTime today=DateTime.now();
            final isCompleted = booking.bookingDate.isBefore(DateTime(today.year, today.month, today.day));
            Color statusColor = isCompleted ? Colors.red : Colors.green;
            String statusText = isCompleted ? "Completed" : "Upcoming";
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Palette.whiteColor,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            booking.workspaceName,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.045),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: w * 0.025, vertical: h * 0.005),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "\$${booking.pricePerHour}/hr",
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        GestureDetector(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirm Delete'),
                                content:
                                Text('Are you sure you want to delete?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Yes'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _deleteBooking(key,booking.workspaceName);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 0.025, vertical: h * 0.005),
                            decoration: BoxDecoration(
                              color: Palette.redColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete,
                              size: w * 0.035,
                              color: Palette.redColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      booking.branch,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: w * 0.03),
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      '$statusText Booking',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.03,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined,
                            size: w * 0.04, color: Colors.grey),
                        SizedBox(width: w * 0.01),
                        Expanded(
                          child: Text(
                            booking.bookingDate.toString().substring(0, 10),
                            style: TextStyle(
                              fontSize: w * 0.032,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timelapse_outlined,
                            size: w * 0.04, color: Colors.grey),
                        SizedBox(width: w * 0.01),
                        Expanded(
                          child: Text(
                            booking.bookingSlot,
                            style: TextStyle(
                              fontSize: w * 0.032,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: w * 0.04, color: Colors.grey),
                        SizedBox(width: w * 0.01),
                        Expanded(
                          child: Text(
                            "${booking.city}, ${booking.location}",
                            style: TextStyle(
                              fontSize: w * 0.032,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.01),
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
