import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/global/variables.dart';
import '../../../models/branch_model.dart';
import '../../../theme/pallete.dart';
import '../../booking/screens/booking_screen.dart';

class BranchView extends StatefulWidget {
  final BranchModel data;
  const BranchView({Key? key, required this.data}) : super(key: key);

  @override
  State<BranchView> createState() => _BranchViewState();
}

class _BranchViewState extends State<BranchView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Palette.whiteColor,
      body: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: w, // image height responsive
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: widget.data.images.map((imageUrl) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                }).toList(),
              ),

              // Back Button
              Positioned(
                top: MediaQuery.of(context).padding.top + w * 0.02,
                left: w * 0.02,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: w * 0.07,
                    width: w * 0.07,
                    decoration: const BoxDecoration(
                      color: Palette.whiteColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back,
                      color: Palette.blackColor,
                      size: w * 0.06,
                    ),
                  ),
                ),
              ),

              // Indicators
              Positioned(
                bottom: w * 0.02,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.data.images.asMap().entries.map((entry) {
                    return Container(
                      width: _currentIndex == entry.key ? w * 0.025 : w * 0.02,
                      height: _currentIndex == entry.key ? w * 0.025 : w * 0.02,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key
                            ? Palette.whiteColor
                            : Palette.whiteColor.withOpacity(0.5),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // Content Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(w * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.data.name ?? '',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: w*0.05),
                          ),
                        ),
                        if (widget.data.pricePerHour != null)
                          Text(
                            "\$${widget.data.pricePerHour}/hr",
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Palette.greenColor,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.data.branch ?? '',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: w*0.04,color: Palette.blackColor),
                          ),
                        ),

                      ],
                    ),



                    SizedBox(height: w * 0.04),

                    // Description
                    Text(
                      widget.data.description ?? '',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: w*0.035,color: Palette.greyColor),

                    ),

                    SizedBox(height: w * 0.03),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Palette.greyColor, size: w * 0.05),
                        SizedBox(width: w * 0.02),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${widget.data.city}", // City highlighted
                                style: TextStyle(
                                  color: Palette.blackColor, // Highlight color
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.035,
                                ),
                              ),
                              TextSpan(
                                text: ", ${widget.data.location}", // Location normal style
                                style: TextStyle(
                                  color: Palette.greyColor,
                                  fontSize: w * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.015),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            color: Palette.greyColor, size: w * 0.05),
                        SizedBox(width: w * 0.02),
                        Text(
                          "Operating Hours: ${widget.data.operatingHours}",
                          style: TextStyle(fontSize: w * 0.035),
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.02),
                      Text(
                        "Amenities",
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: w * 0.02),
                      Wrap(
                        spacing: w * 0.02,
                        children: widget.data.amenities.map((amenity) {
                          return Chip(
                            label: Text(
                              amenity,
                              style: TextStyle(
                                color: Palette.greenColor,
                                fontSize: w * 0.035,
                              ),
                            ),
                            backgroundColor: Colors.green.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w * 0.05),
                              side: BorderSide(color: Palette.greenColor),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: w * 0.05),


                  ],
                ),
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: EdgeInsets.all(w * 0.04),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.greenColor,
                padding: EdgeInsets.symmetric(vertical: w * 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingScreen(data: widget.data)));
              },
              child: Text(
                "Book Now",
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Palette.whiteColor
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
