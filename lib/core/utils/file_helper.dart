import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

abstract class FileHelper {
  List<FileSystemEntity> fetchDirectoryFilesFromPath(String path);
  Future<String> openTextFile(String path);
  FileSystemEntityType getFileSystemType(FileSystemEntity file);
  String? getFileMimeType(String filePath);
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

  @override
  FileSystemEntityType getFileSystemType(FileSystemEntity file) {
    return file.statSync().type;
  }

  @override
  String? getFileMimeType(String filePath) {
    return lookupMimeType(path.extension(filePath));
  }


}