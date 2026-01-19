import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/screens/newsfeed_screen.dart';
import 'package:tuazon_mobprog/screens/notification_screen.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';
import 'package:tuazon_mobprog/screens/profile_screen.dart';
import 'package:tuazon_mobprog/services/user_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final UserDatabase _userDatabase = UserDatabase();
  String _userName = 'Jamaine Tuazon'; // Default name

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Get the logged-in username from database file
      final username = await _userDatabase.getCurrentUser();

      if (username != null && username.isNotEmpty) {
        // Fetch user data from database
        final user = await _userDatabase.findUserByUsername(username);

        if (user != null && mounted) {
          final firstName = user['firstName']?.toString() ?? '';
          final lastName = user['lastName']?.toString() ?? '';
          final fullName = '$firstName $lastName'.trim();

          if (fullName.isNotEmpty && mounted) {
            setState(() {
              _userName = fullName;
            });
          }
        }
      }
    } catch (e) {
      // If error occurs, keep default name
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['Chatterly', 'Notifications', _userName];

    return Scaffold(
      backgroundColor: FB_TEXT_COLOR_WHITE,
      appBar: AppBar(
        backgroundColor: FB_LIGHT_PRIMARY,
        shadowColor: FB_TEXT_COLOR_WHITE,
        elevation: 2,
        title: CustomFont(
          text: titles[_selectedIndex],
          fontSize: ScreenUtil().setSp(25),
          color: FB_TEXT_COLOR_WHITE,
          fontFamily: 'Klavika',
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          NewsfeedScreen(),
          NotificationScreen(),
          ProfileScreen(),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: FB_LIGHT_PRIMARY,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTappedBar,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: FB_TEXT_COLOR_WHITE,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
