import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants.dart';
import '../models/user.dart';
import '../providers/theme_provider.dart';
import '../services/shared_preference.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_inkwell_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SessionService _session = SessionService();

  User? _user;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = await _session.getUser();

    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  Future<void> _onDarkModeChanged(bool value) async {
    context.read<ThemeProvider>().toggleTheme(value);
    await _session.setDarkMode(value);
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: FB_TEXT_COLOR_GREY)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FB_DARK_PRIMARY,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _session.signOut();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: FB_SURFACE,
      appBar: AppBar(
        backgroundColor: FB_LIGHT_PRIMARY,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        title: CustomFont(
          text: 'Settings',
          fontSize: ScreenUtil().setSp(25),
          color: FB_TEXT_COLOR_WHITE,
          fontFamily: 'Klavika',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        children: [
          _buildAccountCard(),
          SizedBox(height: ScreenUtil().setHeight(15)),
          _buildSectionTitle('Preferences'),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Use the dark palette across the whole app',
            value: themeProvider.isDarkMode,
            onChanged: _onDarkModeChanged,
          ),

          SizedBox(height: ScreenUtil().setHeight(15)),
          _buildSectionTitle('Account'),
          _buildInfoTile(Icons.person, 'Username', _user?.username ?? ''),
          _buildInfoTile(Icons.email, 'Email', _user?.email ?? ''),
          _buildInfoTile(Icons.phone, 'Phone', _user?.phone ?? ''),
          _buildInfoTile(
            Icons.badge,
            'User ID',
            _user == null ? '' : '${_user!.id}',
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          CustomInkwellButton(
            onTap: _signOut,
            height: ScreenUtil().setHeight(45),
            width: ScreenUtil().screenWidth,
            buttonName: 'Sign Out',
            fontSize: ScreenUtil().setSp(15),
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    final String image = (_user == null || _user!.image.isEmpty)
        ? 'assets/images/userprofile.jpg'
        : _user!.image;

    return Card(
      color: FB_CARD,
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: FB_SECONDARY,
              backgroundImage: image.startsWith('http')
                  ? CachedNetworkImageProvider(image)
                  : AssetImage(image) as ImageProvider,
            ),
            SizedBox(width: ScreenUtil().setWidth(15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: _user?.fullName ?? '',
                    fontSize: ScreenUtil().setSp(18),
                    color: FB_DARK_PRIMARY,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(3)),
                  CustomFont(
                    text: _user == null ? '' : '@${_user!.username}',
                    fontSize: ScreenUtil().setSp(13),
                    color: FB_TEXT_COLOR_GREY,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(5),
        bottom: ScreenUtil().setHeight(5),
      ),
      child: CustomFont(
        text: title,
        fontSize: ScreenUtil().setSp(16),
        color: FB_DARK_PRIMARY,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: FB_CARD,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: FB_LIGHT_PRIMARY,
        secondary: Icon(icon, color: FB_DARK_PRIMARY),
        title: CustomFont(
          text: title,
          fontSize: ScreenUtil().setSp(15),
          color: FB_TEXT_PRIMARY,
        ),
        subtitle: CustomFont(
          text: subtitle,
          fontSize: ScreenUtil().setSp(11),
          color: FB_TEXT_COLOR_GREY,
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      color: FB_CARD,
      child: ListTile(
        leading: Icon(icon, color: FB_DARK_PRIMARY),
        title: CustomFont(
          text: label,
          fontSize: ScreenUtil().setSp(13),
          color: FB_TEXT_COLOR_GREY,
        ),
        subtitle: CustomFont(
          text: value.isEmpty ? 'Not available' : value,
          fontSize: ScreenUtil().setSp(15),
          color: FB_TEXT_PRIMARY,
        ),
      ),
    );
  }
}
