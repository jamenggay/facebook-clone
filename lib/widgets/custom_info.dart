import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/screens/detail_screen.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';

class CustomInformation extends StatelessWidget {
  const CustomInformation({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    this.icon = const Icon(Icons.person),
    this.profileImageUrl = '',
    this.notifProfile = '',
    this.atProfile = false,
    required this.date,
    this.imageUrl = '',
    required this.numOfLikes,
  });

  final String name;
  final String post;
  final String description;
  final Icon icon;
  final String profileImageUrl;
  final String date;
  final int numOfLikes;
  final bool atProfile;
  final String imageUrl;
  final String notifProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: InkWell(
         onTap: () {
          (atProfile)
              ? print('')
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      userName: name,
                      postContent: post,
                      date: date,
                      numOfLikes: numOfLikes,
                      imageUrl: imageUrl ,
                      profileImageUrl: profileImageUrl,
                    ),
                  ),
                );
        },
        child:  Row(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (notifProfile == '' && profileImageUrl == '')
              ? icon
              : CircleAvatar(
                  radius: 25,
                  backgroundImage: (notifProfile != '')
                      ? (notifProfile.startsWith('http')
                          ? NetworkImage(notifProfile)
                          : AssetImage(notifProfile) as ImageProvider)
                      : (profileImageUrl.startsWith('http')
                          ? NetworkImage(profileImageUrl)
                          : AssetImage(profileImageUrl) as ImageProvider),
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
                  text: date,
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
  
      ),
      
     );
  }
}
