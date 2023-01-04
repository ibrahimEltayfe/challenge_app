import 'dart:async';
import 'dart:developer';
import 'package:archive/archive_io.dart';
import 'package:challenge_app/core/error_handling/exceptions.dart';
import 'package:challenge_app/core/error_handling/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

final githubHelperProvider = Provider<GithubHelper>((ref) {
  return GithubHelper();
});

class GithubHelper{
  Future<Either<Failure,Unit>> downloadAndUnZipRepository(GithubRepository githubRepository) async{
    final zipFileName = githubRepository.repositoryName;
    String url = 'https://github.com/${githubRepository.userName}/${githubRepository.repositoryName}/archive/refs/heads/${githubRepository.branchName}.zip';

    var results = await _downloadAndUnZip(url, '$zipFileName.zip');
    return results.fold(
      (failure){
        return Left(failure);
      },
      (_){
        return const Right(unit);
      }
    );

  }

  Future<Either<Failure,Unit>> _downloadAndUnZip(String url, String fileName) async {
    try{
      final String dir = (await getApplicationDocumentsDirectory()).path;

      //download repository
      await Dio().download(url, '$dir/$fileName',);
      String filePath = '$dir/$fileName';

      //unZip Repository files in 'out/' folder
      await unZipFile(filePath);

      return const Right(unit);
    }catch(e){
      log(e.toString());
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  Future<void> unZipFile(String zipFilePath) async{
      final dir = await getApplicationDocumentsDirectory();

      // Use an InputFileStream to access the zip file without storing it in memory.
      final inputStream = InputFileStream(zipFilePath);
      // Decode the zip from the InputFileStream. The archive will have the contents of the
      // zip, without having stored the data in memory.
      final archive = ZipDecoder().decodeBuffer(inputStream);
      // For all of the entries in the archive
      for (var file in archive.files) {
        // If it's a file and not a directory
        if (file.isFile) {
          // An OutputFileStream will write the data to disk.
          final outputStream = OutputFileStream(path.join(dir.path,'out/${file.name}'));
          // The writeContent method will decompress the file content directly to disk without
          // storing the decompressed data in memory.
          file.writeContent(outputStream);
          // Make sure to close the output stream so the File is closed.
          outputStream.close();
        }
      }
  }

/*
 //old un archive
  Future _unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    final String dir = (await getApplicationDocumentsDirectory()).path;

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(path.join('$dir/out/',filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(path.join('$dir/out/',filename)).create(recursive: true);
      }
    }
  }
  */
}

class GithubRepository{
  final String repositoryName;
  final String branchName;
  final String userName;

  GithubRepository({
    required this.repositoryName,
    required this.branchName,
    required this.userName,
  });

}