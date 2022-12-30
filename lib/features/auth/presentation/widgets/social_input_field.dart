import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/enums/socials_enum.dart';


class SocialInputField extends StatelessWidget {
  final double width;
  final String hint;
  final String? Function(String?)? validator;
  const SocialInputField({
    Key? key,
    this.width = 355,
    this.hint = "https://",
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: SizedBox(
        width:width,
        height: 50,
        child: TextFormField(
          validator: validator,
          style: context.textTheme.titleMedium,
          textDirection: TextDirection.ltr,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: context.theme.primaryColor,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.url,

          decoration: InputDecoration(
            hintText: hint,
            alignLabelWithHint: true,
            filled: false,
            hintStyle: context.textTheme.labelMedium!.copyWith(fontSize: 15),

            prefixIcon: _BuildSocialsDropDownButton(),

            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: context.theme.primaryColor)
            ),

            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: context.theme.primaryColor)
            ),

          ),
        ),
      ),
    );
  }
}

class _BuildSocialsDropDownButton extends StatefulWidget {
  const _BuildSocialsDropDownButton({Key? key}) : super(key: key);

  @override
  State<_BuildSocialsDropDownButton> createState() => _BuildSocialsDropDownButtonState();
}

class _BuildSocialsDropDownButtonState extends State<_BuildSocialsDropDownButton> {
  Socials dropDownButtonValue = Socials.facebook;

  List<Socials> socials = [
    Socials.facebook,
    Socials.google,
    Socials.github,
    Socials.linkedIn
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: DropdownButton<Socials>(
        value: dropDownButtonValue,
        borderRadius: BorderRadius.circular(15),
        alignment: Alignment.center,
        iconEnabledColor: context.theme.primaryColor,
        underline: SizedBox.shrink(),

        onChanged: (value) {
          setState(
              (){
                dropDownButtonValue = value!;
              }
          );

        },
        items: socials.map((socialType){
            return DropdownMenuItem(
              value: socialType,
              child: FaIcon(
                  socialType.getFaIcon,
                  size: 22,
                  color: getColorBasedOnValue(
                      buttonValue: socialType,
                      currentValue: dropDownButtonValue
                  )
              ),
            );
          }).toList()

      ),
    );
  }

  Color getColorBasedOnValue({
    required Socials buttonValue,
    required Socials currentValue
  }){
    if(buttonValue == currentValue){
      return context.theme.primaryColor;
    }else{
      return context.theme.greyColor;
    }
  }
}

