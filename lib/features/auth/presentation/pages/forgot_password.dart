import 'package:challenge_app/core/constants/app_images.dart';
import 'package:challenge_app/core/error_handling/validation.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/auth/presentation/manager/reset_password_provider/reset_password_provider.dart';
import 'package:challenge_app/features/reusable_components/error_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/back_arrow.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final Validation _validation = Validation();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: BackArrow(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Consumer(
              builder: (context,ref,_) {
                final resetPasswordLinkSentState = ref.watch(resetPasswordProvider.select(
                   (state) => state is ResetPasswordLinkSent)
                );

                if(resetPasswordLinkSentState){
                  return Center(
                    child: Text(
                      context.localization.resetPasswordLinkSent,
                      style: context.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25,),
                    const _BuildTitle(),

                    const SizedBox(height: 70,),
                    SvgPicture.asset(AppImages.forgotPassword,width: context.width*0.4,height: 180,),
                    InputTextField(
                        hint: context.localization.enterYourEmail,
                        controller: _emailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        borderRadius: 10,
                        validator: (email) {
                          return _validation.emailValidator(email);
                        },
                    ),

                    const SizedBox(height: 20,),
                    Consumer(
                      builder: (context, WidgetRef ref,_) {
                        final resetPasswordState = ref.watch(resetPasswordProvider);

                        ref.listen(resetPasswordProvider, (previous, current) {
                          if(current is ResetPasswordError){
                            showErrorToast(context, current.message);
                          }
                        });

                        return ActionButton(
                            height: 58,
                            isLoading: resetPasswordState is ResetPasswordLoading,
                            title: context.localization.resetPassword,
                            onTap: (){
                              if(_formKey.currentState!.validate()){
                                ref.read(resetPasswordProvider.notifier).resetPassword(
                                  _emailController.text.trim()
                                );
                              }
                            }
                        );
                      }
                    )

                  ],
                ),
              );
            }
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
              context.localization.forgotPassword,
              style: context.textTheme.displayLarge,
            )
          ],
        ),
      ),
    );
  }
}

