import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/widgets/like_icon.dart';
import 'package:tuazon_mobprog/widgets/share_icon.dart';
import 'package:tuazon_mobprog/widgets/comment_icon.dart';
import '../constants.dart';
import 'custom_font.dart';

class NewsfeedCard extends StatelessWidget {
  final String userName;
  final String postContent;
  final DateTime date;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final String userImage;
  final String? imagePath; 
  final bool
  showPlaceholder; 

  const NewsfeedCard({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    required this.userImage,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.imagePath,
    this.showPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime d) {
      final now = DateTime.now();
      final diff = now.difference(d);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[d.month]} ${d.day}';
    }

    return Card(
      color: FB_TEXT_COLOR_WHITE,
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Padding(
        padding: EdgeInsetsGeometry.all(ScreenUtil().setSp(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage(userImage),
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFont(
                      text: userName,
                      fontSize: ScreenUtil().setSp(15),
                      color: FB_DARK_PRIMARY,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomFont(
                          text: formatDate(date),
                          fontSize: ScreenUtil().setSp(12),
                          color: Colors.grey,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(3)),
                        Icon(
                          Icons.public,
                          color: Colors.grey,
                          size: ScreenUtil().setSp(15),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.more_horiz),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(5)),
            //post content
            CustomFont(
              text: postContent,
              fontSize: ScreenUtil().setSp(12),
              color: FB_DARK_PRIMARY,
            ),
            SizedBox(height: ScreenUtil().setHeight(5)),
            (imagePath != null)
                ? (imagePath!.startsWith('http')
                      ? Image.network(imagePath!, fit: BoxFit.cover)
                      : Image.asset(imagePath!, fit: BoxFit.cover))
                : (showPlaceholder
                      ? Container(
                          height: ScreenUtil().setHeight(150),
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: ScreenUtil().setSp(40),
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : SizedBox(height: ScreenUtil().setHeight(1))),

            // counts row 
            SizedBox(height: ScreenUtil().setHeight(6)),
            Row(
              children: [
                Text(
                  '$likesCount likes',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Spacer(),
                Text(
                  '$commentsCount comments',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(width: ScreenUtil().setWidth(12)),
                Text(
                  '$sharesCount shares',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LikeButton(
                  onPressed: () {
                    print('Liked');
                  },
                  textColor: FB_TEXT_COLOR_GREY,
                ),
                CommentButton(
                  onPressed: () {
                    print('Comment Tapped!');
                  },
                  textColor: FB_TEXT_COLOR_GREY,
                ),
                ShareButton(
                  onPressed: () {
                    print('Shared Tapped!');
                  },
                  textColor: FB_TEXT_COLOR_GREY,
                ),
              ],
            ),

            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage('assets/images/userprofile.jpeg'),
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Container(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(10), 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setHeight(25),
                  width: ScreenUtil().setWidth(330),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setSp(10)),
                    ),
                  ),
                  child: CustomFont(
                    text: 'Write a comment...',
                    fontSize: ScreenUtil().setSp(11),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            CustomFont(
              text: 'View comments',
              fontSize: ScreenUtil().setSp(11),
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
