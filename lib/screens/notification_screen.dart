import 'package:tuazon_mobprog/constants.dart';

import '../widgets/custom_info.dart' as notif;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: FB_TEXT_COLOR_WHITE,
      width: ScreenUtil().screenWidth,
      child: ListView(
        children: const [
          notif.CustomInformation(
            name: 'Celesse Aisle Nacpil',
            description: ' added a post.',
            date: '3h',
            profileImageUrl: 'assets/images/notif7.jpg',
            numOfLikes: 19,
            post: 'Happy new year guys!!!',
          ),
          Divider(),
          notif.CustomInformation(
            name: 'Jorge',
            description: " added a photo.",
            date: '7h',
            profileImageUrl: 'assets/images/notif1.jpg',
            numOfLikes: 15,
            post:'Cloudflare announced a new service recently',
            imageUrl: 'assets/images/notifImage.jpg',
          ),
          Divider(),
          notif.CustomInformation(
            name: 'Raniel Ryan Necio',
            description: 'added a post.',
            date: '15h',
            profileImageUrl: 'assets/images/notif8.jpg',
            numOfLikes: 12,
            post: 'Merry Christmas everyone!'
          ),
          Divider(),
          notif.CustomInformation(
            name: 'BARKGAGI: ',
            description: '"good mood si kuya guard sa gate 1 nagpapapasok naka civilian"',
            date: '11h',
            profileImageUrl: 'assets/images/notif9.jpg',
            numOfLikes: 71,
            post: "good mood si kuya guard sa gate 1 nagpapapasok naka civilian",
          ),
          Divider(),
          notif.CustomInformation(
            name: 'Ronald Rafael Sena',
            description: " added a post.",
            date: '1d',
            profileImageUrl: 'assets/images/notif2.jpg',
            numOfLikes: 7,
            post: "Tara genshin!"

          ),
          Divider(),
          notif.CustomInformation(
            name: 'NU Wizards Circle',
            description: " added a post.",
            date: '1d',
            profileImageUrl: 'assets/images/notif3.jpg',
            post: "Membership Applications have been re-opened!",
            numOfLikes: 65,
          ),
          Divider(),
          notif.CustomInformation(
            name: 'Lance Tuazon',
            description: " reacted to your post.",
            date: '1d',
            notifProfile: 'assets/images/notif4.jpg',
            profileImageUrl: 'assets/images/userprofile.jpg' ,
            numOfLikes: 12,
            post: "BRING BACK MILEVEN. I BELIEVE. lmao"
          ),
          Divider(),
          notif.CustomInformation(
            name: 'Sports Hub',
            description: " mentioned you and other followers in a post.",
            date: '2d',
            profileImageUrl: 'assets/images/notif5.jpg',
            post: "Follow and like our page!",
            numOfLikes: 12,
          ),
          Divider(),
          notif.CustomInformation(
            name: 'NU Wizards Circle',
            description: " added a post.",
            date: '3d',
            profileImageUrl: 'assets/images/notif3.jpg',
            post: "Membership Application is now closed!",
            numOfLikes: 58,
          ),
          Divider(),
          notif.CustomInformation(
            name: 'Tisha Dela Cruz',
            description: " added a post.",
            date: '4d',
            profileImageUrl: 'assets/images/notif6.jpg',
            post: "I miss my jhs friends. uwi na kayo!",
            numOfLikes: 21,
          ),
          Divider(),
          
        ],
      ),
    );
  }
}
