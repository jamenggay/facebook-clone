import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';

class Notification_Tile extends StatelessWidget {
  const Notification_Tile({
    super.key,
    required this.name,
    required this.time,
    required this.description,
    required this.notifProfile,
  });

  final String name;
  final String description;
  final String time;
  final String notifProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: Row(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(notifProfile),
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: FB_DARK_PRIMARY,
                    ),
                    children: [
                      TextSpan(
                        text: "$name ",
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: description),
                    ],
                  ),
                ),

                SizedBox(height: ScreenUtil().setHeight(4)),

                CustomFont(
                  text: time,
                  fontSize: ScreenUtil().setSp(14),
                  color: FB_DARK_PRIMARY,
                  fontStyle: FontStyle.italic,
                ),
              ],
            ),
          ),

          SizedBox(width: ScreenUtil().setWidth(10)),

          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
