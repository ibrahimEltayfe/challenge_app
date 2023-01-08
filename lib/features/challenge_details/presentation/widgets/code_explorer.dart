
import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/config/language_provider.dart';
import 'package:challenge_app/core/constants/app_strings.dart';
import 'package:challenge_app/core/constants/app_themes.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/data/models/file_model.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/file_manager/file_manager_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/pinned_items_provider/pinned_files_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_icons.dart';
import '../../data/models/pinned_file_model.dart';
import 'lottie_widget.dart';

class CodeExplorer extends ConsumerWidget {
  const CodeExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final languageRef = ref.watch(languageProvider);

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

              _BuildFilesBasedOnType()
              
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildFilesBasedOnType extends ConsumerWidget {
  const _BuildFilesBasedOnType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final fileManagerRef = ref.watch(fileManagerProvider);

    if(fileManagerRef is  FileManagerImageFileFetched){
      return _BuildImageFile(
        imageFile:fileManagerRef.imageFile,
        isSvg: fileManagerRef.isSvg,
      );
    }else if(fileManagerRef is FileManagerFilesFetched) {
      return const _BuildFiles();
    } if(fileManagerRef is FileManagerTextFileFetched){
      return _BuildTextFile(text:fileManagerRef.textFileContent);
    }

    return const SizedBox.shrink();
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
    final pinnedFilesRef = ref.watch(pinnedFilesProvider.notifier);
    final pinnedFileState = ref.watch(pinnedFilesProvider);

    ref.listen(fileManagerProvider, (previous, next) {
      if(next is! FileManagerLoading && pinnedFilesRef.pinnedFiles.isNotEmpty){
        //change open pinned files color
        final fileManagerRef = ref.read(fileManagerProvider.notifier);

        final currentPath = fileManagerRef.convertListToPath(fileManagerRef.repoFiles);
        pinnedFilesRef.changeFileOpenState(currentPath);
      }
    });

    if(pinnedFileState is PinnedFilesDataModified){
        if(pinnedFilesRef.pinnedFiles.isEmpty){
          return const SizedBox.shrink();
        }

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
                        itemCount: pinnedFilesRef.pinnedFiles.length,
                        itemBuilder: (context, i) {
                          return _BuildPinnedItem(
                            pinnedFile:pinnedFilesRef.pinnedFiles[i],
                            index: i,
                          );
                        },
                      )
              )
            ],
          ),
        );
      }

    return const SizedBox.shrink();

  }
}

class _BuildPinnedItem extends ConsumerWidget {
  final PinnedFileModel pinnedFile;
  final int index;
  const _BuildPinnedItem({Key? key,required this.pinnedFile, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedFileRef = ref.read(pinnedFilesProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: (){
          pinnedFileRef.goToPinnedFilePath(pinnedFile.filePath);
        },
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
                 pinnedFileRef.removeFileFromPin(index);
               },
               child: const Icon(Icons.close,size: 16,)
              )
             ),

              const SizedBox(width: 5,),

              Text(
                pinnedFile.fileName,
                style: context.textTheme.titleSmall!.copyWith(
                  color: pinnedFile.isOpened ? context.theme.primaryColor: context.theme.greyColor,
                ),
                maxLines: 1,
              ),

              const SizedBox(width:4,),

            ],
          ),
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
    final fileManagerRef = ref.read(fileManagerProvider.notifier);

    return InkWell(
      onTap: (){
        fileManagerRef.repoFiles.add(file.name!);
        fileManagerRef.fetchLocalDirectoryFiles();
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

              const Spacer(),

              if(file.canPin!)
                Flexible(
                  flex: 0,
                  child: InkWell(
                    onTap: (){
                      final filePath = fileManagerRef.convertListToPath(fileManagerRef.repoFiles);

                      final pinnedFile = PinnedFileModel(
                          isOpened: false,
                          fileName: file.name!,
                          filePath: '$filePath/${file.name!}'
                      );

                      ref.read(pinnedFilesProvider.notifier).addFileToPin(pinnedFile);

                    },
                    child: const FittedBox(
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1, ),
          color: const Color(0xfffbfbfb),
        ),
        child: SingleChildScrollView(
          child: Text(text,style: context.textTheme.titleSmall,),
        ),
      ),
    );
  }
}

class _BuildImageFile extends StatelessWidget {
  final File imageFile;
  final bool isSvg;
  const _BuildImageFile ({Key? key, required this.imageFile, required this.isSvg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isSvg
        ? SvgPicture.file(imageFile)
        : Image.file(imageFile),
    );
  }
}
