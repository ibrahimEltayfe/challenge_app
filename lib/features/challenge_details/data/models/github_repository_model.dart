class GithubRepositoryModel{
  String? repositoryName;
  String? branchName;
  String? userName;

  GithubRepositoryModel({
    required this.repositoryName,
    required this.branchName,
    required this.userName,
  });

  factory GithubRepositoryModel.fromMap(Map<String,dynamic> data) {
    return GithubRepositoryModel(
      repositoryName : data["repositoryName"] ?? '',
      branchName: data["branchName"] ?? '',
      userName: data["userName"] ?? ''
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "repositoryName": repositoryName,
      "branchName": branchName,
      "userName": userName
    };
  }

}