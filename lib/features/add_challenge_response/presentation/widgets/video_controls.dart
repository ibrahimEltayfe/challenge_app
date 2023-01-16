import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/common/enums/file_identifier.dart';
import '../manager/import_file/import_file_provider.dart';
import '../manager/video_controllers/video_provider.dart';

class VideoControls extends ConsumerStatefulWidget {
  const VideoControls({Key? key,}) : super(key: key);

  @override
  ConsumerState createState() => _VideoControlsState();
}

class _VideoControlsState extends ConsumerState<VideoControls> with SingleTickerProviderStateMixin{
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250)
    )..addListener(() {setState(() {});});

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final importFileState = ref.watch(importFileProvider);

    ref.listen(videoProvider, (previous, current) {
      if(current is VideoPause){
        _animationController.reverse();
      }else if(current is VideoPlay){
        _animationController.forward();
      }
    });

    if(importFileState is ImportFileDataFetched && ref.watch(videoProvider) is! VideoInitial){
      final List<PlatformFile> files = importFileState.files;
      final fileType = ref.read(importFileProvider.notifier).getFileType(files[0].path ?? '');

      if(fileType == FileIdentifier.video){

        return Container(
          width: 40,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xffeaeaea),
          ),

          child: Column(
            verticalDirection: VerticalDirection.up,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    ref.read(videoProvider.notifier).toggle();
                  },
                  child: Lottie.asset(
                      'assets/lottie/pause_video.json',
                      repeat: false,
                      controller: _animationController,
                      fit: BoxFit.contain
                  ),
                ),
              ),

              Divider(
                height: 1,
                color: context.theme.greyColor,
              ),

              const Expanded(
                child: FittedBox(
                  child: _SpeedControls()
                )
              ),

            ],
          ),
        );

      }
    }

    return const SizedBox.shrink();
  }
}

class _SpeedControls extends ConsumerStatefulWidget {
  const _SpeedControls({Key? key,}) : super(key: key);

  @override
  ConsumerState createState() => __SpeedControlsState();
}

class __SpeedControlsState extends ConsumerState<_SpeedControls> {
  final List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
  ];

  double currentSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(videoProvider.notifier).videoController;

    return PopupMenuButton<double>(
      initialValue: controller.value.playbackSpeed,
      tooltip: 'Playback speed',
      onSelected: (double speed) {
        setState(() {
          currentSpeed = speed;
        });
        controller.setPlaybackSpeed(speed);

      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<double>>[
          for (final double speed in _examplePlaybackRates)
            PopupMenuItem<double>(
              value: speed,
              child: Text('${speed}x'),
            )
        ];
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        child: Text('${currentSpeed}x',style: context.textTheme.titleSmall,),
      ),
    );
  }
}