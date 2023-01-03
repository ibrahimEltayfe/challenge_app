part of 'file_manager_provider.dart';

abstract class FileManagerState extends Equatable {
  const FileManagerState();

  @override
  List<Object> get props => [];
}

class FileManagerInitial extends FileManagerState {}

class FileManagerLoading extends FileManagerState {}

class FileManagerDataFetched extends FileManagerState {
  final List<FileModel> fileModels;
  const FileManagerDataFetched(this.fileModels);

  @override
  List<Object> get props => [fileModels];
}

class FileManagerError extends FileManagerState {
  final String message;
  const FileManagerError(this.message);

  @override
  List<Object> get props => [message];
}