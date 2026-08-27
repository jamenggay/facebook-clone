import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../services/shared_preference.dart';
import '../widgets/custom_font.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SessionService _session = SessionService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));

    final loggedIn = await _session.isLoggedIn();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, loggedIn ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_SURFACE,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/chatbubble.png',
              height: ScreenUtil().setHeight(200),
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            CustomFont(
              text: 'Chatterly',
              fontSize: ScreenUtil().setSp(32),
              color: FB_DARK_PRIMARY,
              fontFamily: 'Klavika',
            ),
          ],
        ),
      ),
    );
  }
}
