import 'package:challenge_app/features/add_challenge_response/presentation/manager/video_controllers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends ConsumerStatefulWidget {
  final String path;
  final bool isNetworkVideo;
  final double height;
  final double width;
  const VideoDisplay({
    Key? key,
    required this.path,
    required this.isNetworkVideo,
    required this.height,
    required this.width
  }) : super(key: key);

  @override
  ConsumerState<VideoDisplay> createState() => _VideoDisplayState();
}

class _VideoDisplayState extends ConsumerState<VideoDisplay> {
  @override
  void initState() {
    super.initState();
    ref.read(videoProvider.notifier).initializeVideoController(path: widget.path);

    //binding cause it rebuilds the screen to play the video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoProvider.notifier).addVideoControllerListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(videoProvider);
    final videoProviderRef = ref.read(videoProvider.notifier);

    return Container(
           width: videoProviderRef.videoWidthInContainer(containerWidth: widget.width),
           height: videoProviderRef.videoWidthInContainer(containerWidth: widget.height),

            padding: const EdgeInsets.all(20),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(videoProviderRef.videoController),
                VideoProgressIndicator(videoProviderRef.videoController, allowScrubbing: true),
              ],
            ),
          );
  }
}


