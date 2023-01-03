import 'dart:developer';

import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/testing/file_manager.dart';
import 'package:flutter/material.dart';

import 'github_helper_test.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({Key? key}) : super(key: key);
  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  final GithubHelper githubHelper = GithubHelper();
  final githubRepository = GithubRepository(
      repositoryName:'weather-app',
      branchName:'main',
      userName:'ibrahimEltayfe'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () async{
            log('clicked');
            //await githubHelper.downloadZip(githubRepository);
            await FileManager.getFile();
          },
          child: Container(
            width: context.width,
            height: context.height,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
