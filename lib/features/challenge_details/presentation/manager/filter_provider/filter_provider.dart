import 'dart:developer';

import 'package:challenge_app/config/providers.dart';
import 'package:challenge_app/features/challenge_details/data/models/filter_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../../../data/repositories/filter_repo.dart';
part 'filter_state.dart';

final selectedFiltersProvider = StateProvider.autoDispose<List<FilterModel>>((ref) {
  return <FilterModel>[];
});

final filterTagsProvider = StateProvider.autoDispose<List<FilterModel>>((ref) {
  return <FilterModel>[...ref.read(selectedFiltersProvider)];
});

final filterProvider = StateNotifierProvider<FilterProvider,FilterState>(
  (ref) => FilterProvider(ref.read(filterRepositoryProvider))..getFilterData()
);

class FilterProvider extends StateNotifier<FilterState> {
  final FilterRepository filterRepository;
  FilterProvider(this.filterRepository) : super(FilterInitial());

  Future<void> getFilterData() async{
    state = FilterLoading();
   final results = await filterRepository.getFilters();

   results.fold(
     (failure){
       state = FilterError(failure.message);
     },
     (results){
       log(results.toString());
       state = FilterDataFetched(results);
     }
   );
  }
}
