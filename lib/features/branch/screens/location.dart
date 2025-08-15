import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/global/variables.dart';
import '../../../models/branch_model.dart';
import '../../../theme/pallete.dart';
import '../controller/branch_controller.dart';

class BranchMap extends ConsumerStatefulWidget {
  @override
  _BranchMapState createState() => _BranchMapState();
}

class _BranchMapState extends ConsumerState<BranchMap> {
  GoogleMapController? mapController;

  Set<Marker> createMarkers(List<BranchModel> branches) {
    return branches.map((branch) {
      return Marker(
        markerId: MarkerId(branch.name),
        position: LatLng(branch.latitude, branch.longitude),
        infoWindow: InfoWindow(title: branch.name),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsyncValue = ref.watch(getBranchProvider(
      (null, null, null),
    ));

    return branchesAsyncValue.when(
      data: (branches) {
        final initialPosition =
             LatLng(branches[0].latitude, branches[0].longitude);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Locate our branches",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: w * 0.045,
                color: Palette.blackColor,
              ),
            ),
          ),
          body: GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 13,
            ),
            markers: createMarkers(branches),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Locate our branches",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: w * 0.045,
              color: Palette.blackColor,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Locate our branches",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: w * 0.045,
              color: Palette.blackColor,
            ),
          ),
        ),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
