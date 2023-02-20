part of 'filter_provider.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilterDataFetched extends FilterState {}

class FilterError extends FilterState {
  final String message;
  const FilterError(this.message);

  @override
  List<Object> get props => [message];
}