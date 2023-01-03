import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_model.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/file_manager/file_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_icons.dart';
import 'lottie_widget.dart';

class CodeExplorer extends StatelessWidget {
  const CodeExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          Text("Code",style: context.textTheme.titleLarge,),

          const SizedBox(height: 8,),
          _BuildCurrentFilePath(),

          SizedBox(height: 15,),
          _PinnedFiles(),

          SizedBox(height: 15,),
          _BuildFiles()
        ],
      ),
    );
  }
}


class _BuildCurrentFilePath extends ConsumerWidget {
  const _BuildCurrentFilePath({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: RichText(
        text: TextSpan(
          children: separatePathToTextSpans(
              context,
              'weather-app-main/'
          ),
        ),
      ),
    );
  }

  List<TextSpan> separatePathToTextSpans(BuildContext context,String path){
    final List<String> separatedText = path.split('/')..remove('');
    final List<TextSpan> textSpans = [];

    for(int i=0; i<separatedText.length; i++){
      final bool isLastItem = i==separatedText.length-1;

      textSpans.add(
          TextSpan(
              text: separatedText[i],
              style: context.textTheme.titleMedium!.copyWith(
                  color: isLastItem
                      ? context.theme.primaryColor
                      : context.theme.darkBlueColor
              )
          ));

      textSpans.add(
          TextSpan(
              text: ' / ',
              style: context.textTheme.titleMedium!.copyWith(
                  color: context.theme.greyColor
              )
          ));
    }

    return textSpans;
  }

}

class _PinnedFiles extends ConsumerWidget {
  const _PinnedFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          FittedBox(
            child: FaIcon(AppIcons.pinFa,size: 19,),
          ),

          SizedBox(width: 10,),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return const _BuildPinnedItem(
                  fileName: 'home.dart',
                  isOpened: false,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _BuildPinnedItem extends StatelessWidget {
  final String fileName;
  final bool isOpened;
  const _BuildPinnedItem({Key? key, required this.fileName, required this.isOpened}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: context.theme.lightGreyColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              child: InkWell(
                  onTap: (){
                    //todo: remove item from pin
                  },
                  child: Icon(Icons.close,size: 16,)
              ),
            ),

            SizedBox(width: 5,),

            FittedBox(
              child: Text(
                fileName,
                style: context.textTheme.titleMedium!.copyWith(
                    color: isOpened ? context.theme.primaryColor: context.theme.greyColor
                ),
              ),
            ),

            SizedBox(width:4,),

          ],
        ),
      ),
    );
  }
}

class _BuildFiles extends ConsumerWidget {
  const _BuildFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileManagerRef = ref.watch(fileManagerProvider);

    if(fileManagerRef is FileManagerError){
      return LottieWidget(
        message: fileManagerRef.message,
        lottiePath: 'assets/lottie/error_mark.json',
        repeat: false,
      );
    }else if(fileManagerRef is FileManagerLoading){
      return const LottieWidget(
        message: 'Loading Files..',
        lottiePath: 'assets/lottie/file_loading.json',
      );
    }else if(fileManagerRef is FileManagerDataFetched){
      final List<FileModel> repoFileModels = fileManagerRef.fileModels;

      return Expanded(
        child: ListView.builder(
          itemCount: repoFileModels.length,
          itemBuilder: (context, i) {
            return _BuildFileContainer(
              file : repoFileModels[i]
            );
          },
        ),
      );;
    }

    return const SizedBox.shrink();
  }
}

class _BuildFileContainer extends StatelessWidget {
  final FileModel file;
  const _BuildFileContainer({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: 397,
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Colors.black, width: 1,),
          color: context.theme.backgroundColor,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            const SizedBox(width: 5,),
            Flexible(
              flex: 0,
              child: FittedBox(
                child: Icon(file.fileIcon),
              ),
            ),

            const SizedBox(width: 10,),

            Expanded(
              flex: 11,
              child: Text(
                file.fileName!,
                style: context.textTheme.titleMedium,
              ),
            ),

            Spacer(),

            if(file.canPin!)
              Flexible(
                flex: 0,
                child: InkWell(
                  onTap: (){
                    //todo:add to pin list
                  },
                  child: FittedBox(
                    child: Icon(AppIcons.pinFa,size: 18,),
                  ),
                ),
              ),

            const SizedBox(width: 2,),

          ],
        ),
      ),
    );
  }
}
