import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/core/error_handling/exceptions.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_model.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_type.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:path/path.dart' as path;

import '../../../../../core/utils/github_helper.dart';
part 'file_manager_state.dart';

final fileManagerProvider = StateNotifierProvider.autoDispose<FileManagerProvider,FileManagerState>(
  //todo:pass github repo
  (ref) => FileManagerProvider()..init()..getLocalRepoFiles()
);

class FileManagerProvider extends StateNotifier<FileManagerState> {
  FileManagerProvider() : super(FileManagerInitial());

  GithubRepository githubRepository = GithubRepository(
      repositoryName: 'weather-app',
      branchName: 'main',
      userName: 'ibrahimEltayfe'
  );

  String mainRepoDirName = '';
  Directory? appDir;
  late List<String> repoFiles = [];

  void init(){
    mainRepoDirName = '${githubRepository.repositoryName}-${githubRepository.branchName}';
    repoFiles.add(mainRepoDirName);
  }

  Future getLocalRepoFiles() async {
    state = FileManagerLoading();
    try{
      appDir ??= await getApplicationDocumentsDirectory();

      final repoLocalDirectory = await getLocalRepositoryDirectory(githubRepository);
      final List<FileSystemEntity> files = repoLocalDirectory.listSync();
      List<FileModel> fileModels = [];

      //re arrange files to put directories at top
      for(int dummy = 0,i = 0;files.length > i; i++){

        if(files[i].statSync().type == FileSystemEntityType.directory){
          final removedFile = files.removeAt(i);
          files.insert(dummy, removedFile);
          dummy++;
        }
       }

      //fill file model
      for(FileSystemEntity file in files){
        final fileModel = FileModel();
        fileModel.fileType = _getFileType(file);
        fileModel.fileName = path.basename(file.path);
        fileModel.fileIcon = fileModel.fileType!.getIcon;
        fileModel.canPin = fileModel.fileType!.canPin;

        fileModels.add(fileModel);
      }

      state = FileManagerDataFetched(fileModels);
    }catch(e){
      log(e.toString());
      state = FileManagerError(ExceptionHandler.handle(e).failure.message) ;
    }
  }

  Future<Directory> getLocalRepositoryDirectory(GithubRepository githubRepository) async{
    Directory repoLocalDirectory = Directory(
      path.join(
        appDir!.path,
        'out/${formatSubFilesAsString()}'
      )
    );

    return repoLocalDirectory;
  }

  String formatSubFilesAsString(){
    String dirSubFiles = '';

    for(String subFileName in repoFiles){
      dirSubFiles += '$subFileName/';
    }

    return dirSubFiles;
  }

  FileType _getFileType(FileSystemEntity file){
    final mime = lookupMimeType(path.extension(file.path));

    if(file.statSync().type == FileSystemEntityType.directory){
      return FileType.directory;
    }else{
      if(mime != null){
        final mimeType = mime.split('/')[0];
        final mimeExtension = mime.split('/')[1];

        if(mimeType == 'image'){
          return FileType.image;
        }else if(mimeType == 'video'){
          return FileType.video;
        }else if(mimeType == 'application' && mimeExtension == 'pdf'){
          return FileType.pdf;
        }else if(mimeType == 'text'){
          return FileType.text;
        }else{
          return FileType.notSupported;
        }
      }else{
        return FileType.text;
      }
    }


  }

}