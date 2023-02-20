import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/add_challenge_response/presentation/manager/media_list_item/media_list_item_provider.dart';
import 'package:challenge_app/features/add_challenge_response/presentation/widgets/image_display.dart';
import 'package:challenge_app/features/reusable_components/action_button.dart';
import 'package:challenge_app/features/reusable_components/back_button_shadow_box.dart';
import 'package:challenge_app/features/reusable_components/input_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                const SizedBox(width: 10,),

                const _BuildMediaContainer(),

                const SizedBox(height: 38,),
                const _BuildGithubTitleBar(),

                const SizedBox(height: 14,),
                _BuildInputForm(scrollController: scrollController)
              ],
            ),

            const Positioned(
                left: 5,
                top: 4,
                child: BackButtonBox()
            ),

          ],
        ),
      ),
    );
  }
}

class _BuildMediaContainer extends StatelessWidget {
  const _BuildMediaContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 400,
        width: 300,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const[
            Expanded(
                child: _MediaContainer()
            ),

            SizedBox(height: 5,),
            _BuildChallengeTitle("Snowing Background"),
          ],
        )
      ),
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

class _MediaContainer extends StatelessWidget {
  const _MediaContainer({Key? key}) : super(key: key);

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
      child: Column(
        children: [
          const _TopColoredBars(),

          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final importFileState = ref.watch(importFileProvider);

                ref.listen(importFileProvider,(previous, current) {
                 if(current is ImportFileError){
                   Fluttertoast.showToast(msg: current.message);
                 }
                },);

                if(importFileState is ImportFileLoading){
                 return const _BuildLoadingWidget();

                } else if(importFileState is ImportFileDataFetched){
                  final List<PlatformFile> files = importFileState.files;

                  return _BuildMediaFiles(files);

                }

                return const MediaImporterWidget();
              },
            ),
          ),
        ],
      )
     );
  }
}

class _TopColoredBars extends StatelessWidget {
  const _TopColoredBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, child) {
          ref.watch(currentMediaItemProvider);
          final currentMediaItemRef = ref.watch(currentMediaItemProvider.notifier);

          final int itemCounts = currentMediaItemRef.filesCount;

          if(itemCounts != 0){
            return Row(
              children: List.generate(itemCounts, (i){
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 5),
                    child: ColoredBox(
                      color: currentMediaItemRef.currentIndex == i
                          ? context.theme.primaryColor
                          : context.theme.greyColor,
                      child: const SizedBox(height: 4,),
                    ),
                  ),
                );
              }),
            );
          }else{
            return const SizedBox.shrink();
          }
        }
    );
  }
}

class _BuildMediaFiles extends ConsumerWidget {
  final List<PlatformFile> files;
  const _BuildMediaFiles(this.files, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final mediaListItemRef = ref.watch(currentMediaItemProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mediaListItemRef.setFilesCount(files.length);
    });

    return LayoutBuilder(
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
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  mediaListItemRef.changeIndex(index);
                },
            ),

            itemBuilder: (_,i,pageIndex){
                return SizedBox(
                    height: size.maxHeight,
                    width: size.maxWidth,
                    child: ImageDisplay(path: files[i].path!,)
                );
            }
        );
      }
    );
  }
}

class _BuildInputForm extends StatefulWidget {
  final ScrollController scrollController;
  const _BuildInputForm({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<_BuildInputForm> createState() => _BuildInputFormState();
}

class _BuildInputFormState extends State<_BuildInputForm> {
  final repositoryUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    repositoryUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Form(
        key: _formKey,
        child: ListView(
          controller:widget.scrollController,
          children: [
            InputTextField(
                height: 56,
                hint: "Github Repository Url",
                controller: repositoryUrlController,
                textInputAction: TextInputAction.done,
                validator: (val){
                  if(val!.isEmpty){
                    return context.localization.fieldIsEmptyError;
                  }
                },
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
        const FaIcon(AppIcons.githubFa,size: 26,),

        const SizedBox(width: 5,),

        Expanded(child: Text(context.localization.addYourRepositoryUrl,style: context.textTheme.titleMedium,))
      ],
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


