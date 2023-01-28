import 'dart:developer';
import 'dart:ui';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/error_handling/validation.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/auth/presentation/manager/register_provider/register_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../reusable_components/double_back_to_exit.dart';
import '../widgets/or_divider.dart';
import '../widgets/social_buttons.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/input_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key,}) : super(key: key);

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Validation _validation = Validation();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();


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
                      const SizedBox(height: 45,),
                      const _BuildTitle(),

                      const SizedBox(height: 60,),
                      InputTextField(
                        hint: context.localization.email,
                        validator: (email){
                          return _validation.emailValidator(email);
                        },
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 25,),
                      InputTextField(
                        hint: context.localization.password,
                        validator: (password){
                          return _validation.registerPasswordValidator(password);
                        },
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        isObscure: true,
                      ),

                      const SizedBox(height:30,),
                      Consumer(
                        builder: (context, ref, child) {
                          final registerState = ref.watch(registerProvider);

                          ref.listen(registerProvider, (previous, current) {
                            if(current is RegisterSuccess){
                              Navigator.pushNamed(context, AppRoutes.emailVerificationCheckRoute);
                            }else if(current is RegisterError){
                              Fluttertoast.showToast(
                                  msg: current.message,
                                  backgroundColor: context.theme.redColor,
                                  textColor: context.theme.whiteColor,
                              );
                            }
                          });

                          return ActionButton(
                            title: context.localization.register,
                            isLoading: registerState is RegisterLoading,

                            onTap: () async{
                              if(_formKey.currentState!.validate()){
                              await ref.read(registerProvider.notifier).register(
                                  emailController.text.trim(),
                                  passwordController.text.trim()
                              );
                            }
                          },

                          );

                        },
                      ),

                      const SizedBox(height:20,),
                      RichText(
                        text:TextSpan(
                            text: context.localization.alreadyHaveAnAccount,
                            style: context.textTheme.titleMedium,
                            children: [
                              TextSpan(
                                  text: context.localization.login,
                                  style: context.textTheme.titleMedium!.copyWith(decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = (){
                                    Navigator.of(context).pushReplacementNamed(AppRoutes.loginRoute);
                                  }
                              )
                            ]
                        ),

                      ),

                      const SizedBox(height:28,),
                      OrDivider(),

                      const SizedBox(height:20,),
                      SocialButtons(),

                      const SizedBox(height:20,),

                    ],
                  ),
                ),
              ),
            ),
          ),
        )
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