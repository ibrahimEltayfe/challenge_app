part of 'media_list_item_provider.dart';

abstract class CurrentMediaItemState extends Equatable {
  const CurrentMediaItemState();

  @override
  List<Object> get props => [];
}

class CurrentMediaItemInitial extends CurrentMediaItemState {}

class CurrentMediaItemChanged extends CurrentMediaItemState {}
