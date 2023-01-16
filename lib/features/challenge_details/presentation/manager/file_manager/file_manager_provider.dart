import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/core/error_handling/exceptions.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_model.dart';
import 'package:challenge_app/core/common/enums/file_identifier.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../../core/utils/file_helper.dart';
import '../../../../../core/utils/github_helper.dart';
part 'file_manager_state.dart';

final fileManagerProvider = StateNotifierProvider.autoDispose<FileManagerProvider,FileManagerState>(
  //todo:pass github repo
  (ref){
    final FileHelper localFileHelper = LocalFileHelper();
    return FileManagerProvider(localFileHelper)..init();
  }
);

class FileManagerProvider extends StateNotifier<FileManagerState> {
  final FileHelper _fileHelper;
  FileManagerProvider(this._fileHelper) : super(FileManagerInitial());

  String mainRepoDirName = '';
  Directory? appDir;
  late List<String> repoFiles = [];

  GithubRepository githubRepository = GithubRepository(
      repositoryName: 'weather-app',
      branchName: 'main',
      userName: 'ibrahimEltayfe'
  );

  Future<void> init() async{
    state = FileManagerLoading();

    mainRepoDirName = '${githubRepository.repositoryName}-${githubRepository.branchName}';
    repoFiles.add(mainRepoDirName);

    try{
      appDir = await getApplicationDocumentsDirectory();
      await fetchLocalDirectoryFiles();
    }catch(e){
      log(e.toString());
      state = FileManagerError(ExceptionHandler.handle(e).failure.message);
    }
  }

  Future fetchLocalDirectoryFiles() async {
    state = FileManagerLoading();

    try{
      final currentPath = path.join(appDir!.path, 'out${convertListToPath(repoFiles)}');
      final FileIdentifier fileType = _fileHelper.getFileType(File(currentPath));
      //if the current path is not directory
      if(fileType != FileIdentifier.directory){
        //todo:check for other types like: image,..

        if(fileType == FileIdentifier.image){
          state = FileManagerImageFileFetched(File(currentPath));
        } else if(fileType == FileIdentifier.svgImage){
          state = FileManagerImageFileFetched(File(currentPath),isSvg: true);
        } else{
          //todo: it opens the file as text even if there is no text mime type for it
          final text = await _fileHelper.openTextFile(currentPath);
          state = FileManagerTextFileFetched(text);
        }

        return;
      }

      final List<FileSystemEntity> files = _fileHelper.fetchDirectoryFilesFromPath(currentPath);
      List<FileModel> fileModels = [];

      //re arrange files to put directories at top
      for(int dummy = 0,i = 0;files.length > i; i++){
        final FileIdentifier fileType = _fileHelper.getFileType(files[i]);
        if(fileType == FileIdentifier.directory){
          final removedFile = files.removeAt(i);
          files.insert(dummy, removedFile);
          dummy++;
        }
      }

      //fill file model
      for(FileSystemEntity file in files){
        final fileModel = FileModel();
        fileModel.type = _fileHelper.getFileType(file);
        fileModel.name = path.basename(file.path);
        fileModel.icon = fileModel.type!.getIcon;
        fileModel.canPin = fileModel.type!.canPin;

        fileModels.add(fileModel);
      }

      state = FileManagerFilesFetched(fileModels);
    }catch(e){
      log(e.toString());
      state = FileManagerError(ExceptionHandler.handle(e).failure.message) ;
    }
  }

  String convertListToPath(List<String> files){
    //convert subFiles list to path
    String localFilePath = '';

    for(String subFileName in files){
      localFilePath += '/$subFileName';
    }

    return localFilePath;
  }

  List<String> convertPathToList(String path){
    //convert path to list
    final files = path.split('/')..remove('');
    return files;
  }


}