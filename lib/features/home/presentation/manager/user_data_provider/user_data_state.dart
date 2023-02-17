part of 'user_data_provider.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataFetched extends UserDataState {}

class UserDataError extends UserDataState {
  final String message;
  const UserDataError(this.message);

  @override
  List<Object> get props => [message];
}