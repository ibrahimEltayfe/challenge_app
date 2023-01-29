import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/profile/data/models/socail_link_model.dart';
import 'package:flutter/material.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/input_text_field.dart';
import '../../../auth/presentation/widgets/social_input_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController titleController = TextEditingController();

  List<SocialLinkModel> socialLinks = [];
  List<Widget> socialTextFields = [];

  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),

            children: [
              const SizedBox(height: 25,),
              const _BuildPageTitle(),

              const SizedBox(height: 25,),

              _BuildTextHeadline(context.localization.name),
              InputTextField(
                  width: 355,
                  hint: 'Your name',
                  controller: nameController,
                  textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 15,),

              _BuildTextHeadline(context.localization.title),
              InputTextField(
                width: 355,
                hint: 'Flutter Developer',
                controller: nameController,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 15,),

              _BuildTextHeadline(context.localization.socialLinks),
              ...socialTextFields,

              SizedBox(height: 5,),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ActionButton(
                  width: 70,
                  height: 42,
                  title: context.localization.add,
                  onTap: (){
                    //todo: change setState
                    setState(() {
                      socialTextFields.add(
                          SocialInputField()
                      );
                    });
                  }
                ),
              ),

              SizedBox(height: 25,),
              ActionButton(
                  title: context.localization.done,
                  onTap: (){
                    //todo:
                    Navigator.pushNamed(context, AppRoutes.homeRoute);
                  }
              ),

              SizedBox(height: 20,),

            ],
          ),
        ),
      ),

    );
  }
}

class _BuildPageTitle extends StatelessWidget {
  const _BuildPageTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -14,
            right: 18,
            width: 302,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: context.theme.lightOrangeColor,
              ),
            ),
          ),
          Text(
              'Setup Profile',
              style: context.textTheme.displayLarge!.copyWith(
                  fontSize: 43
              )
          ),
        ],
      ),
    );
  }
}

class _BuildTextHeadline extends StatelessWidget {
  final String text;
  const _BuildTextHeadline(this.text,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 3,
          top: 8,
          bottom: 8
      ),
      child: Text(
        text,
        style: context.textTheme.titleMedium!.copyWith(
            fontSize: 19
        ),
      ),
    );
  }
}

