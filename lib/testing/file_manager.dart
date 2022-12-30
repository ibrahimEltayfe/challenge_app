import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileManager{
  static Future getFile() async{
    final String dir = (await getApplicationDocumentsDirectory()).path;

    final List<FileSystemEntity> files = Directory(
        path.join('$dir/out/','weather-app-main')
    ).listSync();

    for(FileSystemEntity file in files){
      final a = Directory(file.path).statSync().type;
      log(a.toString());
    }
  }
}