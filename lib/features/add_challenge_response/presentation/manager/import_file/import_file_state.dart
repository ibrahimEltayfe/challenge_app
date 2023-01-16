part of 'import_file_provider.dart';

abstract class ImportFileState extends Equatable {
  const ImportFileState();

  @override
  List<Object> get props => [];
}

class ImportFileInitial extends ImportFileState {}

class ImportFileLoading extends ImportFileState {}

class ImportFileDataFetched extends ImportFileState {
  final List<PlatformFile> files;
  const ImportFileDataFetched(this.files);

  @override
  List<Object> get props => [files];
}

class ImportFileError extends ImportFileState {
  final String message;
  const ImportFileError(this.message);

  @override
  List<Object> get props => [message];
}