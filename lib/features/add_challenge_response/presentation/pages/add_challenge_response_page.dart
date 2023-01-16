import 'package:carousel_slider/carousel_slider.dart';
import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/add_challenge_response/presentation/manager/video_controllers/video_provider.dart';
import 'package:challenge_app/features/add_challenge_response/presentation/widgets/image_display.dart';
import 'package:challenge_app/features/add_challenge_response/presentation/widgets/video_controls.dart';
import 'package:challenge_app/features/add_challenge_response/presentation/widgets/video_display.dart';
import 'package:challenge_app/features/reusable_components/action_button.dart';
import 'package:challenge_app/features/reusable_components/back_button_shadow_box.dart';
import 'package:challenge_app/features/reusable_components/input_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/common/enums/file_identifier.dart';
import '../manager/import_file/import_file_provider.dart';
import '../widgets/media_importer.dart';

class AddChallengeResponsePage extends StatefulWidget {
  const AddChallengeResponsePage({Key? key}) : super(key: key);

  @override
  State<AddChallengeResponsePage> createState() => _AddChallengeResponsePageState();
}

class _AddChallengeResponsePageState extends State<AddChallengeResponsePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              children: [
                SizedBox(width: 10,),

                SizedBox(
                  height: 410,
                  width: 350,
                  child: Stack(
                    children:[
                     Positioned(
                         right: 0,
                         top: 0,
                         width: 300,
                         height: 400,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: const[
                              Expanded(
                                child: _MediaImporterContainer()
                              ),
                              SizedBox(height: 5,),
                             _BuildChallengeTitle("Snowing Background"),
                           ],
                         ),
                       ),

                      const Positioned(
                        left: 35,
                        bottom: 37,
                        child: VideoControls(),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 28,),
                _BuildGithubTitleBar(),

                const SizedBox(height: 15,),
                _BuildFormFields(scrollController: scrollController)
              ],
            ),

            Positioned(
                left: 5,
                top: 4,
                child: BackButtonShadowBox()
            ),

          ],
        ),
      ),
    );
  }
}

class _BuildFormFields extends StatefulWidget {
  final ScrollController scrollController;
  const _BuildFormFields({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<_BuildFormFields> createState() => _BuildFormFieldsState();
}

class _BuildFormFieldsState extends State<_BuildFormFields> {
  final usernameController = TextEditingController();
  final repositoryNameController = TextEditingController();
  final branchNameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    repositoryNameController.dispose();
    branchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Form(
        child: ListView(
          controller:widget.scrollController,
          children: [
            InputTextField(
                height: 56,
                hint: "Github username",
                controller: usernameController,
                textInputAction: TextInputAction.next
            ),
            const SizedBox(height: 12,),

            InputTextField(
                height: 56,
                hint: "Repository name",
                controller: repositoryNameController,
                textInputAction: TextInputAction.next
            ),
            const SizedBox(height: 12,),

            InputTextField(
                height: 56,
                hint: "Branch name",
                controller: branchNameController,
                textInputAction: TextInputAction.next
            ),

            const SizedBox(height: 12,),


            ActionButton(
              title: context.localization.shareYourCreativity,
              onTap: (){

             }
            )

          ],
        ),
      ),
    );
  }
}

class _BuildGithubTitleBar extends StatelessWidget {
  const _BuildGithubTitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(AppIcons.githubFa,size: 26,),

        SizedBox(width: 5,),

        Expanded(child: Text("Kindly fill the data below to fetch your repository:",style: context.textTheme.titleMedium,))
      ],
    );
  }
}


class _BuildChallengeTitle extends StatelessWidget {
  final String title;
  const _BuildChallengeTitle(this.title,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: context.textTheme.titleMedium!.copyWith(fontSize: 19),
      ),
    );
  }
}

class _MediaImporterContainer extends StatelessWidget {
  const _MediaImporterContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.primaryColor, width: 1),
        color: const Color(0xfffbfbfb),
      ),
      child: _MediaImporterHandler()
     );
  }
}

class _MediaImporterHandler extends ConsumerWidget {

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final importFileState = ref.watch(importFileProvider);

    ref.listen(importFileProvider,(previous, current) {
      if(current is ImportFileError){
        Fluttertoast.showToast(msg: current.message);
      }
    },);

    if(importFileState is ImportFileLoading){
      //Loading..
      return const _BuildLoadingWidget();

    } else if(importFileState is ImportFileDataFetched){
      //build files container based on file type..
      final List<PlatformFile> files = importFileState.files;

      return _MediaDisplayer(files);

    }

    return const MediaImporterWidget();
  }
}

class _MediaDisplayer extends ConsumerWidget {
  final List<PlatformFile> files;
  const _MediaDisplayer(this.files, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return  LayoutBuilder(
      builder: (context,size) {
        return CarouselSlider.builder(
            itemCount: files.length,
            options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                height: double.infinity,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal
            ),

            itemBuilder: (_,i,pageIndex){
              final fileType = ref.read(importFileProvider.notifier).getFileType(files[i].path ?? '');

              if(fileType == FileIdentifier.image){

                return SizedBox(
                    height: size.maxHeight,
                    width: size.maxWidth,
                    child: ImageDisplay(path: files[i].path!,)
                );

              }else if(fileType == FileIdentifier.video){

                return VideoDisplay(
                  width: size.maxWidth,
                  height: size.maxHeight,
                  isNetworkVideo: false,
                  path: files[i].path!,
                );

              }

              return const SizedBox.shrink();
            }
        );
      }
    );
  }
}


class _BuildLoadingWidget extends StatelessWidget {
  const _BuildLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.12,
        heightFactor: 0.1,
        child: CircularProgressIndicator(color: context.theme.primaryColor,)
    );
  }
}


