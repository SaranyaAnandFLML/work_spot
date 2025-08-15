import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../../core/common/notification_service.dart';
import '../../../core/global/variables.dart';
import '../../../core/utils.dart';
import '../../../models/booking_model.dart';
import '../../../models/branch_model.dart';
import '../../../models/booking_slot_model.dart';
import '../../../models/notification_model.dart';
import '../../../theme/pallete.dart';
import '../../branch/screens/home_page.dart';
import '../controller/booking_controller.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final BranchModel data;
  const BookingScreen({super.key, required this.data});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String? selectedSlot;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(bookingControllerProvider);
      controller.loadDatesForBranch(widget.data.id).then((_) {
        final today = DateTime.now();
        controller.availableDates = controller.availableDates.where((dateStr) {
          final date = DateTime.parse(dateStr);
          return !date.isBefore(DateTime(today.year, today.month, today.day));
        }).toList();
        controller.notifyListeners();
      });
    });
  }

  Future<void> saveBooking({
    required String bookingSlot,
    required DateTime bookingDate, // the date of the slot
    required String workspaceName,
    required String city,
    required String branch,
    required String location,
    required double pricePerHour,
  }) async {
    final box = await Hive.openBox<Booking>('bookings');
    final box1 = await Hive.openBox<NotificationModel>('notifications');

    final booking = Booking(
      bookingTime: DateTime.now(),
      bookingSlot: bookingSlot,
      bookingDate: bookingDate,
      userId: userId,
      workspaceName: workspaceName,
      city: city,
      branch: branch,
      pricePerHour: pricePerHour,
      location: location,
    );

    await box.add(booking);

    final notification = NotificationModel(
      title: "Booking Confirmed!",
      message: "your booking for $workspaceName has been confirmed",
    );
    await box1.add(notification);
    final notificationService = NotificationService();
    notificationService.showNotification(notification);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(bookingControllerProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book a Slot",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: w * 0.045,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: h * 0.015),

          // Branch Name
          Text(
            widget.data.name ?? '',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: w * 0.05,
            ),
          ),
          SizedBox(height: h * 0.02),

          // Location
          Row(
            children: [
              SizedBox(width: w * 0.04),
              Icon(Icons.location_on_outlined,
                  color: Palette.greyColor, size: w * 0.055),
              SizedBox(width: w * 0.015),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.data.city ?? '',
                        style: TextStyle(
                          color: Palette.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.035,
                        ),
                      ),
                      TextSpan(
                        text: ", ${widget.data.location ?? ''}",
                        style: TextStyle(
                          color: Palette.greyColor,
                          fontSize: w * 0.032,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.012),

          // Operating Hours
          Row(
            children: [
              SizedBox(width: w * 0.04),
              Icon(Icons.access_time,
                  color: Palette.greyColor, size: w * 0.055),
              SizedBox(width: w * 0.015),
              Expanded(
                child: Text(
                  "Operating Hours: ${widget.data.operatingHours ?? ''}",
                  style: TextStyle(fontSize: w * 0.032),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.025),

          // Dates list
          if (controller.availableDates.isNotEmpty)
            SizedBox(
              height: h * 0.1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.availableDates.length,
                itemBuilder: (context, index) {
                  final date = controller.availableDates[index];
                  final isSelected = controller.selectedDate == DateTime.parse(date);

                  return GestureDetector(
                    onTap: () {
                      selectedSlot = null;
                      final localController = ref.read(bookingControllerProvider);
                      localController.selectedDate = DateTime.parse(date);
                      localController.notifyListeners();
                      localController.loadSlotsForDate(date);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.04, vertical: w * 0.025),
                      margin: EdgeInsets.all(w * 0.015),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(w * 0.02),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        date,
                        style: TextStyle(
                          color: isSelected
                              ? Palette.whiteColor
                              : Palette.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: w * 0.032,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: h * 0.015,child: Divider(color: Palette.greyColor,),),

          // No slots msg
          if (controller.selectedDate != null && controller.slots.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No slots available for this date",
                  style: TextStyle(fontSize: w * 0.038),
                ),
              ),
            )

          // Slots
          else if (controller.slots.isNotEmpty)
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(w * 0.03),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: w * 0.025,
                  crossAxisSpacing: w * 0.025,
                  childAspectRatio: 3,
                ),
                itemCount: controller.slots.length,
                itemBuilder: (context, index) {
                  final Slot slot = controller.slots[index];
                  final bool isAvailable = slot.status == "available";
                  final bool isSelected = selectedSlot == slot.time;

                  Color backgroundColor;
                  if (!isAvailable) {
                    backgroundColor = Palette.greyColor;
                  } else if (isSelected) {
                    backgroundColor = Palette.greenColor;
                  } else {
                    backgroundColor = Colors.lightBlue[100]!;
                  }

                  return GestureDetector(
                    onTap: isAvailable
                        ? () {
                      setState(() {
                        selectedSlot = slot.time;
                      });
                    }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(w * 0.02),
                        border: Border.all(
                          color: isSelected
                              ? Colors.green[800]!
                              : Colors.transparent,
                          width: w * 0.005,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slot.time,
                        style: TextStyle(
                          color: isSelected
                              ? Palette.whiteColor
                              : (isAvailable ? Palette.blackColor : Palette.whiteColor),

                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.035,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          if (controller.slots.isNotEmpty)
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSlot != null
                      ? Palette.greenColor
                      : Palette.greyColor,
                  minimumSize: Size(double.infinity, h * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.02),
                  ),
                ),
                onPressed: selectedSlot != null
                    ? () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      title:  Text("Confirm Booking", style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: w * 0.045,
                        color: Palette.blackColor,
                      ),),
                      content: Text(
                        "Are you sure you want to book ${widget.data.name} at ${selectedSlot} on ${controller.selectedDate}?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            saveBooking(
                              bookingSlot: selectedSlot!,
                              bookingDate: (controller.selectedDate)!,
                              workspaceName: widget.data.name,
                              city: widget.data.city,
                              branch: widget.data.branch,
                              pricePerHour: widget.data.pricePerHour,
                              location: widget.data.location,
                            ).then((onValue) {
                              showSnackBar(context, 'Booking confirmed!');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomePage()),
                                    (Route<dynamic> route) => false,
                              );
                            });
                          },
                          child: const Text("confirm"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("cancel"),
                        )
                      ],
                    ),
                  );
                }
                    : null,
                child: Text(
                  "Confirm Booking",
                  style: TextStyle(
                    color: Palette.whiteColor,
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
