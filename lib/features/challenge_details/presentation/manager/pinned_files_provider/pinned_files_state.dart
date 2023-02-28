part of 'pinned_files_provider.dart';

abstract class PinnedFilesState extends Equatable {
  const PinnedFilesState();

  @override
  List<Object> get props => [];
}

class PinnedFilesInitial extends PinnedFilesState {}

class PinnedFilesDataModified extends PinnedFilesState {}