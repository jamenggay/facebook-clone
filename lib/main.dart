import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

// Entry point of the app. The app is wrapped in a ChangeNotifierProvider so the
// ThemeProvider (app state) is available to every screen in the widget tree.
void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const TuazonFacebook(),
  ),
);

// Root widget of the application.
class TuazonFacebook extends StatelessWidget {
  const TuazonFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the ThemeProvider so the MaterialApp rebuilds whenever the theme
    // is toggled anywhere in the app (this is the app-state part of the lab).
    final themeProvider = context.watch<ThemeProvider>();

    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',
          // Light theme keeps the existing look of the app.
          theme: ThemeData.light(),
          // Dark theme is applied across the whole app when toggled on.
          darkTheme: ThemeData.dark(),
          // themeMode comes from the ThemeProvider (app state).
          themeMode: themeProvider.themeMode,
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
