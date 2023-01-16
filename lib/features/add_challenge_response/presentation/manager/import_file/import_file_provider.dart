import 'dart:io';

import 'package:challenge_app/core/common/enums/file_identifier.dart';
import 'package:challenge_app/core/utils/file_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod/riverpod.dart';
part 'import_file_state.dart';

final importFileProvider = StateNotifierProvider.autoDispose<ImportFileProvider,ImportFileState>(
  (ref){
    final FileHelper fileHelper = LocalFileHelper();
    return ImportFileProvider(fileHelper);
  }
);

class ImportFileProvider extends StateNotifier<ImportFileState> {
  final FileHelper fileHelper;
  ImportFileProvider(this.fileHelper) : super(ImportFileInitial());

  Future importFile() async{
    state = ImportFileLoading();

    final pickedFiles = await fileHelper.pickFiles();
    pickedFiles.fold(
      (failure) => state = ImportFileError(failure.message),
      (files){
        files.removeWhere((element) => element.path == null || element.path!.isEmpty);
        state = ImportFileDataFetched(files);
      }
    );
  }

  FileIdentifier getFileType(String path){
    return fileHelper.getFileType(File(path));
  }
}
