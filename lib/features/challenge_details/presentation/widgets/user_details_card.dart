import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

class UserDetailsCard extends StatelessWidget {
  final double? height;
  final double? width;
  final String name;
  final String title;
  final double nameFontSize;
  final double titleFontSize;
  final String imageUrl;
  final double imageSize;

  const UserDetailsCard({
    Key? key,
    this.height,
    this.width,
    required this.name,
    required this.title,
    this.nameFontSize = 14,
    this.titleFontSize = 13,
    required this.imageUrl,
    this.imageSize = 39,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //todo: forward to user`s profile page
      },
      child: SizedBox(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
             SizedBox(
               width: imageSize,
               height: imageSize,
               child: const CircleAvatar(
                 backgroundColor: Colors.grey,
               ),
             ),

            const SizedBox(width: 4,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: TextDirection.ltr,

              children: [
                Expanded(
                  child: Text(
                    name,
                    style: context.textTheme.titleSmall!.copyWith(
                        fontSize: nameFontSize
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),

                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.titleSmall!.copyWith(
                        fontSize: titleFontSize,
                        color: context.theme.greyColor
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}