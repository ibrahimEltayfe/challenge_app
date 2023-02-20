import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
part 'filter_state.dart';

final filterProvider = StateNotifierProvider<FilterProvider,FilterState>(
  (ref) => FilterProvider()
);

class FilterProvider extends StateNotifier<FilterState> {
  FilterProvider() : super(FilterInitial());

  Future getFilterData() async{

  }
}
