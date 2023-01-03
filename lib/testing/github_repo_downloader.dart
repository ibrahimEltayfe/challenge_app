import 'dart:io';
import 'package:challenge_app/testing/github_helper_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestGithub extends StatefulWidget {
  const TestGithub({Key? key}) : super(key: key);

  @override
  State<TestGithub> createState() => _TestGithubState();
}

class _TestGithubState extends State<TestGithub> {

  final githubHelper = GithubHelper();
  late final GithubRepository githubRepository;

  @override
  void initState() {
    githubRepository = GithubRepository(
        repositoryName:'weather-app',
        branchName:'main',
        userName:'ibrahimEltayfe'
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: githubHelper.downloadZip(githubRepository),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            return Center(child: Text("Done"),);
          }
        )

      ),

    );
  }
}
