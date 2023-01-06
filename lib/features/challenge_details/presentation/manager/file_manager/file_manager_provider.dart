import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/core/error_handling/exceptions.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_model.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../../core/utils/github_helper.dart';
part 'file_manager_state.dart';

final fileManagerProvider = StateNotifierProvider.autoDispose<FileManagerProvider,FileManagerState>(
  //todo:pass github repo
  (ref) => FileManagerProvider()..init()
);

class FileManagerProvider extends StateNotifier<FileManagerState> {
  FileManagerProvider() : super(FileManagerInitial());

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
      final currentPath = path.join(appDir!.path, 'out${_formatFilesListToPath()}');

      //if the current path is not directory
      if(!_isDirectory(currentPath)){
        //todo:check for other types like: image,..
        final text = await openTextFile();
        state = FileManagerTextFileFetched(text);
        return;
      }

      final localDirectory = Directory(currentPath);
      final List<FileSystemEntity> files = localDirectory.listSync();
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
        fileModel.type = _getFileType(file);
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

  bool _isDirectory(String path){
    final File file = File(path);
    
    return file.statSync().type == FileSystemEntityType.directory;
  }

  Future<String> openTextFile() async{
    String text;

    final File file = File(path.join(appDir!.path, 'out${_formatFilesListToPath()}'));

    text = await file.readAsString();

    return text;
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
        }else if(mimeExtension == 'pdf'){
          return FileType.pdf;
        }else if(mimeType == 'text'){
          return FileType.text;
        }else if(mimeExtension == 'json'){
          return FileType.json;
        }else{
          return FileType.notSupported;
        }
      }else{
        return FileType.text;
      }
    }

  }

  String _formatFilesListToPath(){
    //convert subFiles list to path
    String localFilePath = '';

    for(String subFileName in repoFiles){
      localFilePath += '/$subFileName';
    }

    return localFilePath;
  }

}