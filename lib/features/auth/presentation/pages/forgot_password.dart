import 'package:challenge_app/core/constants/app_images.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/back_arrow.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackArrow(),

              SizedBox(height: 25,),
              _BuildTitle(),

              SizedBox(height: 70,),
              SvgPicture.asset(AppImages.forgotPassword,width: context.width*0.4,height: 180,),
              InputTextField(
                  hint: context.localization.enterYourEmail,
                  controller: _emailController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress
              ),

              SizedBox(height: 20,),
              ActionButton(
                  title: context.localization.resetPassword,
                  onTap: (){
                    //todo:send verification code
                  }
              )

            ],
          ),
        ),
      ),
    );
  }
}

class _BuildTitle extends StatelessWidget {
  const _BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
              width: 258,
              height: 58,
              bottom: -10,
              end: -15,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: ColoredBox(
                  color: context.theme.lightOrangeColor,
                ),
              ),
            ),
            Text(
              context.localization.forgotPassword.replaceAll(' ', '\n'),
              style: context.textTheme.displayLarge,
            )
          ],
        ),
      ),
    );
  }
}

