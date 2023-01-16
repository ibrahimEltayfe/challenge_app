import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/core/common/enums/file_identifier.dart';
import 'package:challenge_app/core/constants/app_errors.dart';
import 'package:challenge_app/core/error_handling/dio_errors.dart';
import 'package:challenge_app/core/error_handling/exceptions.dart';
import 'package:challenge_app/core/error_handling/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

abstract class FileHelper {
  List<FileSystemEntity> fetchDirectoryFilesFromPath(String path);
  Future<String> openTextFile(String path);
  FileIdentifier getFileType(FileSystemEntity file);
  Future<Either<Failure,List<PlatformFile>>> pickFiles();
  String? getFileMime(String filePath);
}

class LocalFileHelper implements FileHelper{
  @override
  List<FileSystemEntity> fetchDirectoryFilesFromPath(String path) {
    final localDirectory = Directory(path);
    return localDirectory.listSync();
  }

  @override
  Future<String> openTextFile(String filePath) async{
    final File file = File(filePath);
    return await file.readAsString();
  }

  FileSystemEntityType _getFileSystemType(FileSystemEntity file) {
    return file.statSync().type;
  }

  @override
  Future<Either<Failure,List<PlatformFile>>> pickFiles() async{
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null) {
        List<PlatformFile> files = result.files;

        log(files.toString());

        return Right(files);
      } else {
        // User canceled the picker
        return const Left(PickFileFailure(AppErrors.noFilePicked));
      }
    }catch(e){
      log(e.toString());
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  String? getFileMime(String filePath) {
    return lookupMimeType(path.extension(filePath));
  }

  @override
  FileIdentifier getFileType(FileSystemEntity file){
    if(_getFileSystemType(file) == FileSystemEntityType.directory){
      return FileIdentifier.directory;
    }else{
      String? mime = getFileMime(file.path);

      if(mime != null){
        final mimeIdentifiers = mime.split('/');
        final mimeType = mimeIdentifiers[0];
        final mimeExtension = mimeIdentifiers[1];

        if(mimeType == 'image'){
          if(mimeExtension == 'svg+xml'){
            return FileIdentifier.svgImage;
          }else{
            return FileIdentifier.image;
          }
        } else if(mimeType == 'video'){
          return FileIdentifier.video;
        }else if(mimeExtension == 'pdf'){
          return FileIdentifier.pdf;
        }else if(mimeType == 'text' || mimeExtension=='xml'){
          return FileIdentifier.text;
        }else if(mimeExtension == 'json'){
          return FileIdentifier.json;
        }else{
          return FileIdentifier.notSupported;
        }
      }else{
        return FileIdentifier.notSupported;
      }
    }

  }

}