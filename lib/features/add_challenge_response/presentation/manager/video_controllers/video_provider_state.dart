part of 'video_provider.dart';

abstract class VideoProviderState extends Equatable {
  const VideoProviderState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoProviderState {}

class VideoLoading extends VideoProviderState {}

class VideoDataInitialized extends VideoProviderState {}

class VideoPause extends VideoProviderState {}

class VideoPlay extends VideoProviderState {}

class VideoBuildFrame extends VideoProviderState {}

class VideoError extends VideoProviderState {
  final String message;
  const VideoError(this.message);

  @override
  List<Object> get props => [message];
}