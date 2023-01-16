import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/app_icons.dart';
import '../manager/import_file/import_file_provider.dart';

class MediaImporterWidget extends ConsumerWidget {
  const MediaImporterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async{
        await ref.read(importFileProvider.notifier).importFile();
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FittedBox(child: FaIcon(AppIcons.importFileFa,size: 35,)),
          const SizedBox(height: 10,),
          FittedBox(
              child: Text("Upload your video, images or GIF.",style: context.textTheme.titleMedium,)
          ),
        ],
      ),
    );
  }
}