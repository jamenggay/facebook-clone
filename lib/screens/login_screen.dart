import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_dialogs.dart';
import '../services/user_service.dart';
import '../services/shared_preference.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  final SessionService _session = SessionService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Please enter your username.',
      );
      return;
    }
    if (password.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Please enter your password.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final loggedInUser = await _userService.login(username, password);

      if (loggedInUser == null) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        customDialog(
          context,
          title: 'Login Failed',
          content:
              'Invalid username or password. Please check your credentials '
              'and try again.',
        );
        return;
      }

      final fullProfile = await _userService.getUserById(loggedInUser.id);

      await _session.saveUser(
        fullProfile == null
            ? loggedInUser
            : fullProfile.withToken(loggedInUser.token),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      customDialog(
        context,
        title: 'Connection Error',
        content:
            'Could not reach the server. Please check your internet '
            'connection and try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_SURFACE,
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(40),
                  color: FB_LIGHT_PRIMARY,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/chatbubble.png',
                        height: ScreenUtil().setHeight(200),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: FB_DARK_PRIMARY,
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: usernameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your username' : null,
                        onSaved: (value) =>
                            usernameController.text = value ?? '',
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: FB_TEXT_COLOR_DARKGREY,
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Username',
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: passwordController,
                        isObscure: _obscurePassword,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                        onSaved: (value) =>
                            passwordController.text = value ?? '',
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: FB_TEXT_COLOR_DARKGREY,
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: FB_PRIMARY,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      _isLoading
                          ? SizedBox(
                              height: ScreenUtil().setHeight(40),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: FB_LIGHT_PRIMARY,
                                ),
                              ),
                            )
                          : CustomInkwellButton(
                              onTap: () async => await login(),
                              height: ScreenUtil().setHeight(40),
                              width: ScreenUtil().screenWidth,
                              buttonName: 'Login',
                              fontSize: ScreenUtil().setSp(15),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(40),
                  color: FB_LIGHT_PRIMARY,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You do not have an account? ',
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            color: FB_DARK_PRIMARY,
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
