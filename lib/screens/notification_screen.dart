import 'package:tuazon_mobprog/constants.dart';

import '../widgets/notification.dart' as notif;
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
          notif.Notification_Tile(
            name: 'Celesse Aisle Nacpil',
            description: ' commented on your photo: "Inaakit mo ba ako?"',
            time: '3h',
            notifProfile: 'assets/images/notif7.jpg',
          ),
          Divider(),
          notif.Notification_Tile(
            name: 'Jorge',
            description: " shared nixCraft's post.",
            time: '7h',
            notifProfile: 'assets/images/notif1.jpg',
          ),
          Divider(),
          notif.Notification_Tile(
            name: 'Ronald Rafael Sena',
            description: " reacted to a photo you shared.",
            time: '1d',
            notifProfile: 'assets/images/notif2.jpg',
          ),
          Divider(),
          notif.Notification_Tile(
            name: 'NU Wizards Circle',
            description: " added a post.",
            time: '1d',
            notifProfile: 'assets/images/notif3.jpg',
          ),
          Divider(),
          notif.Notification_Tile(
            name: 'Lance Tuazon',
            description: " reacted to a photo you shared.",
            time: '1d',
            notifProfile: 'assets/images/notif4.jpg',
          ),
          Divider(),
          notif.Notification_Tile(
            name: 'Sports Hub',
            description: " mentioned you and other followers in a post.",
            time: '2d',
            notifProfile: 'assets/images/notif5.jpg',
          ),
          Divider(),
          notif.Notification_Tile(
            name: 'NU Wizards Circle',
            description: " added 5 new photos.",
            time: '3d',
            notifProfile: 'assets/images/notif3.jpg',
          ),
          Divider(),
          notif.Notification_Tile(
            name: 'Tisha Dela Cruz',
            description: " shared your post.",
            time: '4d',
            notifProfile: 'assets/images/notif6.jpg',
          ),
          Divider(),
          
        ],
      ),
    );
  }
}
