import 'package:coworking_space/features/booking/screens/notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/global/variables.dart';
import '../../../theme/pallete.dart';
import '../../booking/screens/my_bookings.dart';
import '../controller/branch_controller.dart';
import 'branch_view.dart';
import 'location.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomePage> {

  TextEditingController searchController = TextEditingController();
  final searchInputProvider = StateProvider<String>((ref) => '');
  final filterTypeProvider = StateProvider<String>((ref) => '');
  final filterInputProvider = StateProvider<String>((ref) => '');

  List<String> city=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w*0.28),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Palette.greenColor,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Work Spot',
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Palette.whiteColor,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero, // remove default padding
                          constraints: BoxConstraints(), // remove default constraints if needed
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookings())),
                          icon: Icon(Icons.file_present_rounded, color: Palette.whiteColor),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BranchMap())),
                          icon: Icon(Icons.location_on, color: Palette.whiteColor),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications())),
                          icon: Icon(Icons.notifications, color: Palette.whiteColor),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: w*0.02),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: w*0.1,
                          decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Palette.greyColor),
                              SizedBox(width: w*0.02),
                              Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (value) => ref.read(searchInputProvider.notifier).state = value,
                                    decoration: InputDecoration(
                                      hintText: 'Search work space',
                                      border: InputBorder.none,
                                      suffixIcon: ref.watch(searchInputProvider).isNotEmpty
                                          ? IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          searchController.clear();
                                          ref.read(searchInputProvider.notifier).state = '';
                                        },
                                      )
                                          : null,
                                    ),

                                  )

                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: w*0.02),
            Container(
              width: w * 0.1,
              height: w * 0.1,
              decoration: BoxDecoration(
                color:Palette.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ref.watch(filterInputProvider) == ''
                  ? PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'price') {
                    final order = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(100, 100, 0, 0),
                      items: [
                        PopupMenuItem(
                          onTap: ()=> ref.read(filterInputProvider.notifier).state = 'Low to High',
                          value: 'low',
                          child: Text('Low to High'),
                        ),
                        PopupMenuItem(
                          onTap: ()=> ref.read(filterInputProvider.notifier).state = 'High to Low',
                          value: 'high',
                          child: Text('High to Low'),
                        ),
                      ],
                    );
                    if (order != null) {
                      ref.read(filterTypeProvider.notifier).state = 'price';
                    }
                  } else if (value == 'city') {
                    if (city.isEmpty) return; // avoid empty error
                    final order = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(100, 100, 0, 0),
                      items: city.map((cityName) {
                        return PopupMenuItem<String>(
                          onTap: ()=> ref.read(filterInputProvider.notifier).state = cityName,
                          value: cityName,
                          child: Text(cityName),
                        );
                      }).toList(),
                    );
                    if (order != null) {
                      ref.read(filterTypeProvider.notifier).state = 'city';
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'price', child: Text("Sort by Price")),
                  const PopupMenuItem(value: 'city', child: Text("Sort by City")),
                ],
                child: Icon(Icons.sort),
              )
                  : IconButton(
                icon: Icon(Icons.close, color: Palette.redColor),
                onPressed: () {
                  ref.read(filterInputProvider.notifier).state = '';
                  ref.read(filterTypeProvider.notifier).state = '';
                },
              ),
            )


            ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.fromLTRB(w*0.06, w*0.03, w*0.06, w*0.06),
        child: Column(
          children: [
            Expanded(
                child:
        ref.watch(getBranchProvider((
            ref.watch(searchInputProvider),
            ref.watch(filterTypeProvider),
            ref.watch(filterInputProvider),
            ))).when(
                  data: (objects) {
                    return objects.isEmpty
                        ? const Center(child: Text('NO DATA FOUND'))
                        : ListView.builder(
                      itemCount: objects.length,
                      itemBuilder: (context, index) {
                        final branch = objects[index];
                        city = objects.map((branch) => branch.city).toSet().toList();

                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>BranchView(data: branch,)));
                          },
                          child: Container(
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
                                          branch.name,
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: w*0.045),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.025, vertical: h * 0.005),
                                        decoration: BoxDecoration(
                                          color:Palette.greenColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "\$${branch.pricePerHour}/hr",
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: h * 0.005),
                                  Text(
                                    branch.branch,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: w*0.03),
                                  ),
                                  SizedBox(height: h * 0.01),

                                  // Location
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: w*0.04, color: Palette.greyColor),
                                      SizedBox(width: w * 0.01),
                                      Expanded(
                                        child: Text(
                                          "${branch.city}, ${branch.location}",
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
          ],
        ),
      ),
    );
  }
}
