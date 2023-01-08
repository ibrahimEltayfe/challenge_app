import 'dart:developer';

import 'package:challenge_app/features/challenge_details/presentation/manager/file_manager/file_manager_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/models/pinned_file_model.dart';
part 'pinned_files_state.dart';

final pinnedFilesProvider = StateNotifierProvider.autoDispose<PinnedFilesProvider,PinnedFilesState>(
  (ref) => PinnedFilesProvider(ref)
);

class PinnedFilesProvider extends StateNotifier<PinnedFilesState> {
  final Ref ref;
  PinnedFilesProvider(this.ref) : super(PinnedFilesInitial());

  List<PinnedFileModel> pinnedFiles = [];

  addFileToPin(PinnedFileModel fileModel){
    for(PinnedFileModel pinFile in pinnedFiles){
      if(pinFile.filePath == fileModel.filePath){
        return;
      }
    }

      pinnedFiles.add(fileModel);
      state = PinnedFilesDataModified();

  }

  removeFileFromPin(int index){
    pinnedFiles.removeAt(index);
    state = PinnedFilesDataModified();
  }

  goToPinnedFilePath(String path) async{
    final fileManagerRef = ref.read(fileManagerProvider.notifier);
    final List<String> files = fileManagerRef.convertPathToList(path);
    fileManagerRef.repoFiles = files;

    await fileManagerRef.fetchLocalDirectoryFiles();
    state = PinnedFilesDataModified();

  }

  changeFileOpenState(String currentPath){
    pinnedFiles = pinnedFiles.map((e){
      if(currentPath == e.filePath){
        e.isOpened = true;
      }else{
        e.isOpened = false;
      }

      return e;
    }).toList();

    state = PinnedFilesDataModified();
  }

}
