
import 'package:challenge_app/config/language_provider.dart';
import 'package:challenge_app/core/constants/app_strings.dart';
import 'package:challenge_app/core/constants/app_themes.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_model.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/file_manager/file_manager_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_icons.dart';
import 'lottie_widget.dart';

class CodeExplorer extends ConsumerWidget {
  const CodeExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final languageRef = ref.watch(languageProvider);
    final fileManagerRef = ref.watch(fileManagerProvider);

    return Expanded(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: AppThemes.lightTheme(context,languageRef).copyWith(
            textTheme: AppThemes.lightTheme(context,languageRef).textTheme.apply(
                fontFamily: AppStrings.senFont,
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Code",style: context.textTheme.titleLarge,),

              const SizedBox(height: 8,),
              const _BuildCurrentFilePath(),

              const SizedBox(height: 15,),
              const _BuildPinnedFiles(),

              const SizedBox(height: 15,),
              
              if(fileManagerRef is FileManagerFilesFetched)
                const _BuildFiles()
              
              else if(fileManagerRef is FileManagerTextFileFetched)
                _BuildTextFile(text:fileManagerRef.textFileContent)
                
              
            ],
          ),
        ),
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
    ref.watch(fileManagerProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: RichText(
        text: TextSpan(
          children: separatePathToTextSpans(
              context,
              ref.watch(fileManagerProvider.notifier)
            ),
        ),
      ),
     );
  }

  List<TextSpan> separatePathToTextSpans(
      BuildContext context,
      FileManagerProvider fileManagerRef
   ){
    final List<TextSpan> textSpans = [];
    final files = fileManagerRef.repoFiles;

    for(int i=0; i<files.length; i++){
      final bool isLastItem = i==files.length-1;

      textSpans.add(
          TextSpan(
              text: ' / ',
              style: context.textTheme.titleMedium!.copyWith(
                  color: context.theme.greyColor
              )
          ));

      textSpans.add(
          TextSpan(
            text: files[i],
            style: context.textTheme.titleMedium!.copyWith(
                color: isLastItem
                    ? context.theme.primaryColor
                    : context.theme.darkBlueColor
            ),
            recognizer: TapGestureRecognizer()..onTap = (){
              if(i == files.length-1){
                return;
              }
              fileManagerRef.repoFiles.replaceRange(i+1, files.length, []);
              fileManagerRef.fetchLocalDirectoryFiles();
            }
      ));
    }

    return textSpans;
  }

}

class _BuildPinnedFiles extends ConsumerWidget {
  const _BuildPinnedFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          const FittedBox(
            child: FaIcon(AppIcons.pinFa,size: 19,),
          ),

         const SizedBox(width: 10,),

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

            const SizedBox(width: 5,),

             Text(
              fileName,
              style: context.textTheme.titleSmall!.copyWith(
                  color: isOpened ? context.theme.primaryColor: context.theme.greyColor,
              ),
              maxLines: 1,
            ),

            const SizedBox(width:4,),

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
    }else if(fileManagerRef is FileManagerFilesFetched){
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
      );
    }

    return const SizedBox.shrink();
  }
}

class _BuildFileContainer extends ConsumerWidget {
  final FileModel file;
  const _BuildFileContainer({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return InkWell(
      onTap: (){
        final fileManagerRef = ref.read(fileManagerProvider.notifier);
        fileManagerRef.repoFiles.add(file.name!);
        ref.read(fileManagerProvider.notifier).fetchLocalDirectoryFiles();
      },
      child: Padding(
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
                  child: Icon(file.icon),
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                flex: 11,
                child: Text(
                  file.name!,
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
      ),
    );
  }
}

class _BuildTextFile extends StatelessWidget {
  final String text;
  const _BuildTextFile({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1, ),
            color: const Color(0xfffbfbfb),
          ),
          child: Text(text,style: context.textTheme.titleSmall,),

        ),
      ),
    );
  }
}
