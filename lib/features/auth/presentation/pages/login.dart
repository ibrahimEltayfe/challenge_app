import 'dart:developer';

import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/auth/presentation/manager/login_provider/login_provider.dart';
import 'package:challenge_app/features/auth/presentation/widgets/social_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/error_handling/validation.dart';
import '../../../../main.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/double_back_to_exit.dart';
import '../../../reusable_components/input_text_field.dart';
import '../widgets/or_divider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key,}) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  final Validation _validation = Validation();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToExit(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40,),
                    const _BuildTitle(),

                    const SizedBox(height: 52,),
                    InputTextField(
                      hint: context.localization.email,
                      validator: (email){
                        return _validation.emailValidator(email);
                      },
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24,),
                    InputTextField(
                      hint: context.localization.password,
                      validator: (password){
                        return _validation.loginPasswordValidator(password);
                      },
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      isObscure: true,
                    ),

                    const SizedBox(height: 6,),
                    const _BuildForgotPassword(),

                    const SizedBox(height:30,),
                    Consumer(
                      builder: (context, ref, child) {
                        final loginState = ref.watch(loginProvider);

                        ref.listen(loginProvider, (previous, current) {
                          if(current is LoginSuccess){
                            if(current.isEmailVerified){
                              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeRoute, (route) => false);
                            }else{
                              Navigator.pushNamed(context, AppRoutes.emailVerificationCheckRoute);
                            }
                          }else if(current is LoginError){
                            Fluttertoast.showToast(
                              msg: current.message,
                              backgroundColor: context.theme.redColor,
                              textColor: context.theme.whiteColor,
                            );
                          }
                        });


                        return ActionButton(
                          title: context.localization.login,
                          isLoading: loginState is LoginLoading,
                          onTap: () async{
                            if(_formKey.currentState!.validate()){
                              await ref.read(loginProvider.notifier).login(
                                  emailController.text.trim(),
                                  passwordController.text.trim()
                              );
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(height:16,),
                    const _BuildDoNotHaveAnAccount(),

                    const SizedBox(height:28,),
                    const OrDivider(),

                    const SizedBox(height:20,),
                    const SocialButtons(),

                    const SizedBox(height:20,),

                  ],
                ),
              ),
            ),
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
    return SizedBox(
      width: context.width*0.86,
      height: 140,
      child: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'UI Developers',
                style: context.textTheme.displayLarge
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: context.theme.lightOrangeColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 1),
              child: Text(
                  'Challenges',
                  style: context.textTheme.displayLarge
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildForgotPassword extends StatelessWidget {
  const _BuildForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.forgotPasswordRoute);
      },
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: Padding(
          padding: EdgeInsetsDirectional.only(end: context.width*0.09),
          child: Text(
            context.localization.forgotPassword,
            style: context.textTheme.titleSmall!.copyWith(
                decoration: TextDecoration.underline
            ),),
        ),
      ),
    );
  }
}

class _BuildDoNotHaveAnAccount extends StatelessWidget {
  const _BuildDoNotHaveAnAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text:TextSpan(
          text: context.localization.doNotHaveAnAccount + ' ',
          style: context.textTheme.titleMedium,
          children: [
            TextSpan(
                text: context.localization.register,
                style: context.textTheme.titleMedium!.copyWith(
                    decoration: TextDecoration.underline
                ),
                recognizer: TapGestureRecognizer()..onTap = (){
                  Navigator.of(context).pushReplacementNamed(AppRoutes.registerRoute);
                }
            )
          ]
      ),
    );
  }
}