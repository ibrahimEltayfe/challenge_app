part of 'file_manager_provider.dart';

abstract class FileManagerState extends Equatable {
  const FileManagerState();

  @override
  List<Object> get props => [];
}

class FileManagerInitial extends FileManagerState {}

class FileManagerLoading extends FileManagerState {}

class FileManagerFilesFetched extends FileManagerState {
  final List<FileModel> fileModels;
  const FileManagerFilesFetched(this.fileModels);

  @override
  List<Object> get props => [fileModels];
}

class FileManagerTextFileFetched extends FileManagerState {
  final String textFileContent;
  const FileManagerTextFileFetched(this.textFileContent);

  @override
  List<Object> get props => [textFileContent];
}

class FileManagerError extends FileManagerState {
  final String message;
  const FileManagerError(this.message);

  @override
  List<Object> get props => [message];
}