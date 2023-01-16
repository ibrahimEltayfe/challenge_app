import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
part 'media_list_item_state.dart';

final currentMediaItemProvider = StateNotifierProvider.autoDispose<CurrentMediaItemProvider,CurrentMediaItemState>(
  (ref) => CurrentMediaItemProvider()
);

class CurrentMediaItemProvider extends StateNotifier<CurrentMediaItemState> {
  CurrentMediaItemProvider() : super(CurrentMediaItemInitial());

  int filesCount = 0;
  int currentIndex = 0;

  setFilesCount(int count){
    filesCount = count;
    state = CurrentMediaItemChanged();

  }

  changeIndex(int newIndex){
    currentIndex = newIndex;
    state = CurrentMediaItemChanged();
  }

}
