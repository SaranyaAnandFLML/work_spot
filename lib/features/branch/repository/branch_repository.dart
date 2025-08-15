import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/branch_model.dart';

final branchRepositoryProvider = Provider((ref) {
  return BranchRepository();
});

class BranchRepository{
  BranchRepository();

  Future<List<BranchModel>> getBranches(
      String? search,
      String? filterType,
      String? filterValue,
      ) async {
    print("Search: $search");
    print("FilterType: $filterType");
    print("FilterValue: $filterValue");

    await Future.delayed(const Duration(seconds: 1));

    // Load JSON file
    final String response =
    await rootBundle.loadString('assets/json_files/mock_branches.json');
    final List<dynamic> data = json.decode(response);

    // Convert JSON to BranchModel list
    List<BranchModel> branches =
    data.map((e) => BranchModel.fromJson(e)).toList();

    // 1. Apply Search (if given)
    if (search != null && search.trim().isNotEmpty) {
      branches = branches.where((branch) {
        final nameMatch = branch.name?.toLowerCase().contains(search.toLowerCase()) ?? false;
        final cityMatch = branch.city?.toLowerCase().contains(search.toLowerCase()) ?? false;
        return nameMatch || cityMatch;
      }).toList();
    }

    // 2. Apply Filter Type
    if (filterType != null && filterValue != null) {
      if (filterType == 'price') {
        if (filterValue == 'Low to High') {
          branches.sort((a, b) => (a.pricePerHour ?? 0).compareTo(b.pricePerHour ?? 0));
        } else if (filterValue == 'High to Low') {
          branches.sort((a, b) => (b.pricePerHour ?? 0).compareTo(a.pricePerHour ?? 0));
        }
      } else if (filterType == 'city') {
        branches = branches
            .where((branch) =>
        (branch.city ?? '').toLowerCase() == filterValue.toLowerCase())
            .toList();
      }
    }

    return branches;
  }



}