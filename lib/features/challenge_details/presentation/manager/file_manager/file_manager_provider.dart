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
  (ref) => FileManagerProvider()..getLocalRepoFiles(
      GithubRepository(
          repositoryName: 'weather-app',
          branchName: 'main',
          userName: 'ibrahimEltayfe'
      )
  )
);

class FileManagerProvider extends StateNotifier<FileManagerState> {
  FileManagerProvider() : super(FileManagerInitial());

  Future getLocalRepoFiles(GithubRepository githubRepository) async {
    state = FileManagerLoading();
    try{
      final repoLocalDirectory = await _getLocalRepositoryDirectory(githubRepository);
      final List<FileSystemEntity> files = repoLocalDirectory.listSync();
      List<FileModel> fileModels = [];

      for(int dummy = 0,i = 0;files.length > i; i++){
        //re arrange files to put directories at top
        if(files[i].statSync().type == FileSystemEntityType.directory){
          final removedFile = files.removeAt(i);
          files.insert(dummy, removedFile);
          dummy++;
        }
       }

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
      state = FileManagerError(ExceptionHandler.handle(e).failure.message) ;
    }
  }

  Future<Directory> _getLocalRepositoryDirectory(GithubRepository githubRepository) async{
    final dir = await getApplicationDocumentsDirectory();
    Directory repoLocalDirectory = Directory(
        path.join(
            dir.path,
            'out/${githubRepository.repositoryName}-${githubRepository.branchName}'
        )
    );

    return repoLocalDirectory;
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