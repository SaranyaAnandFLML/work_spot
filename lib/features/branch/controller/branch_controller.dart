import 'package:coworking_space/features/branch/repository/branch_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/branch_model.dart';

final branchControllerProvider = StateNotifierProvider<BranchController, bool>(
      (ref) => BranchController(
    branchRepository: ref.watch(branchRepositoryProvider),
  ),
);

// Your family provider expecting a tuple
final getBranchProvider =
FutureProvider.family<List<BranchModel>, (String?, String?, String?)>((ref, params) async {
  final repository = ref.read(branchRepositoryProvider);
  return repository.getBranches(params.$1, params.$2, params.$3);
});





class BranchController extends StateNotifier<bool> {
  final BranchRepository _branchRepository;

  BranchController({required BranchRepository branchRepository})
      : _branchRepository = branchRepository,
        super(false);

  Future<List<BranchModel>> getBranches(String? search,String? filterType, String? filterValue) async {
    final postList = await _branchRepository.getBranches(search,filterType,filterValue);
    return postList;
  }

}