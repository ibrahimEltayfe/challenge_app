import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
import 'package:video_player/video_player.dart';
part 'video_provider_state.dart';

final videoProvider = StateNotifierProvider.autoDispose<VideoProvider,VideoProviderState>(
  (ref) => VideoProvider()
);

class VideoProvider extends StateNotifier<VideoProviderState> {
  late final VideoPlayerController videoController;
  VideoProvider() : super(VideoInitial());

  void initializeVideoController({required String path}){
    videoController = VideoPlayerController.file(File(path));
  }

  void addVideoControllerListeners(){
    videoController.initialize().then((_){

      videoController.addListener((){

        if(videoController.value.duration == videoController.value.position){
          if(state is! VideoPause){
            state = VideoPause();
          }
        }

      });

      videoController.play();
      state = VideoPlay();

    });
  }

  void _pauseVideo() {
    videoController.pause().then((value){
      state = VideoPause();
    });
  }

  void _playVideo(){
    videoController.play().then((value){
      state = VideoPlay();
    });
  }

  void toggle(){
    if(videoController.value.isPlaying){
      _pauseVideo();
    }else{
      _playVideo();
    }
  }

  double videoWidthInContainer({required double containerWidth}){
    final videoActualWidth =  videoController.value.size.width;
    if(videoActualWidth > containerWidth){
      return containerWidth;
    }else{
      return videoActualWidth;
    }
  }

  double videoHeightInContainer({required double containerHeight}){
    final videoActualHeight = videoController.value.size.height;

    if(videoActualHeight > containerHeight){
      return containerHeight;
    }else{
      return videoActualHeight;
    }
  }


  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }
}
