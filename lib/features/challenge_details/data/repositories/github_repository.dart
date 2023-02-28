import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/config/type_def.dart';
import 'package:path/path.dart' as path;
import 'package:archive/archive_io.dart';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error_handling/exceptions.dart';
import '../../../../core/error_handling/failures.dart';
import '../../../../core/utils/network_checker.dart';
import '../data_sources/github_remote.dart';
import '../models/github_repository_model.dart';

abstract class GithubRepository{
  FutureEither<Unit> downloadAndUnZipRepository(GithubRepositoryModel githubRepository);
}

class GithubRepositoryImpl implements GithubRepository{
  final GithubRemote _githubRemote;
  final NetworkInfo _connectionChecker;
  const GithubRepositoryImpl(this._githubRemote, this._connectionChecker);

  @override
  Future<Either<Failure,Unit>> downloadAndUnZipRepository(GithubRepositoryModel githubRepository) async{
    return await _handleFailures(() async{
      String url = 'https://github.com/${githubRepository.userName}/${githubRepository.repositoryName}/archive/refs/heads/${githubRepository.branchName}.zip';
      final fileName = githubRepository.repositoryName;
      final String dir = (await getApplicationDocumentsDirectory()).path;

      log(url.toString());
      //download repository and save it locally
      await _githubRemote.downloadRepositoryCode(
        url: url,
        saveFilePath: '$dir/$fileName'
      );

      //unZip repository files
      String zipFilePath = '$dir/$fileName';
      //unZip Repository files in 'out/' folder
      await _unZipFile(zipFilePath,dir);

      return const Right(unit);

    });
  }

  Future<void> _unZipFile(String zipFilePath,String appDirectoryPath) async{

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
        final outputStream = OutputFileStream(path.join(appDirectoryPath,'out/${file.name}'));
        // The writeContent method will decompress the file content directly to disk without
        // storing the decompressed data in memory.
        file.writeContent(outputStream);
        // Make sure to close the output stream so the File is closed.
        outputStream.close();
      }
    }

    //delete zip file after finishing the extraction
    File(zipFilePath).delete().ignore();
  }

  Future gg() async{
    throw('ee');
  }
  Future<Either<Failure, Unit>> _handleFailures(Future Function() task) async{
    if(await _connectionChecker.isConnected) {
      try{
        await task();
        return const Right(unit);
      }catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }
    }else{
      return Left(NoInternetFailure());
    }
  }

}