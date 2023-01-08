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

class FileManagerImageFileFetched extends FileManagerState {
  final File imageFile;
  final bool isSvg;
  const FileManagerImageFileFetched(this.imageFile,{this.isSvg = false});

  @override
  List<Object> get props => [imageFile];
}

class FileManagerError extends FileManagerState {
  final String message;
  const FileManagerError(this.message);

  @override
  List<Object> get props => [message];
}