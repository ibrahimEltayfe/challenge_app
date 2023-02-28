import 'package:dio/dio.dart';

class GithubRemote{
  Future<void> downloadRepositoryCode({required String url, required String saveFilePath}) async{
    await Dio().download(url, saveFilePath);
  }
}