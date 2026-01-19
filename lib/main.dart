import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

void main() => runApp(const TuazonFacebook());

class TuazonFacebook extends StatelessWidget {
  const TuazonFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/newsfeed': (context) => const NewsfeedScreen(),
            '/home': (context) => const HomeScreen(),
            '/notification': (context) => NotificationScreen(),
          },
        );
      },
    );
  }
}
