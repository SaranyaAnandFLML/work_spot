import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/utils.dart';
import '../../../models/notification_model.dart';
import '../../../theme/pallete.dart';
import '../../notification/controller/notifications_controller.dart';
import '../controller/booking_controller.dart';

class MyBookings extends ConsumerStatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends ConsumerState<MyBookings> {

  Future<void> deleteBooking(int bookingKey, NotificationModel notification, WidgetRef ref) async {
    await ref.watch(bookingControllerProvider).deleteBooking(bookingKey,notification,ref).then((onValue){
      showSnackBar(context, 'Booking deleted!');
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bookingControllerProvider).loadBookings());
  }

  @override
  Widget build(BuildContext context) {
    final asyncBookings = ref.watch(myBookingsProvider);

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.06, w * 0.03, w * 0.06, w * 0.06),
        child: asyncBookings.when(
          data: (objects) {
            return objects.isEmpty
                ? const Center(child: Text('NO DATA FOUND'))
                :ListView.builder(
                    itemCount: objects.length,
                    itemBuilder: (context, index) {
                      final booking = objects[index];
                      final key = booking.key as int;
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
                                        NotificationModel noti=NotificationModel(
                                            title: 'Booking deleted!',
                                            message: 'your booking for ${booking.workspaceName} workspace has been deleted!');
                                        deleteBooking(key,noti,ref);

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
                  );
          },
          error: (error, stack) {
            if (kDebugMode) {
              print(error);
              return ErrorText(error: error.toString());
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Something went wrong!',style: TextStyle(color: Palette.redColor,fontWeight: FontWeight.bold,fontSize: w*0.04),)
                  ],
                ),
              );
            }
          },
          loading: () {
            return Loader();
          },
        )
      ),
    );
  }
}
