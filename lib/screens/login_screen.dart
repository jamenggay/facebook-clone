import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_dialogs.dart';
import '../services/user_database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserDatabase _userDatabase = UserDatabase();
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Clear error message when user types
    usernameController.addListener(() {
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
    passwordController.addListener(() {
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Validate username
  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Please enter your username.',
      );
      return 'Username is required';
    }
    final username = value.trim();
    if (username.length < 3) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Username must be at least 3 characters long.',
      );
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Please enter your password.',
      );
      return 'Password is required';
    }
    if (value.length < 6) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must be at least 6 characters long.',
      );
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login() async {
    // Clear previous error message
    setState(() {
      _errorMessage = null;
    });

    // Validate username
    final usernameError = _validateUsername(usernameController.text);
    if (usernameError != null) return;

    // Validate password
    final passwordError = _validatePassword(passwordController.text);
    if (passwordError != null) return;

    try {
      final username = usernameController.text.trim();
      final password = passwordController.text;

      // Validate credentials from database
      final isValid = await _userDatabase.validateCredentials(
        username: username,
        password: password,
      );

      if (!mounted) return;

      if (isValid) {
        // Store the logged-in username in database file
        await _userDatabase.setCurrentUser(username);

        // Credentials are correct, navigate to home screen (which contains newsfeed)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error dialog for invalid credentials
        customDialog(
          context,
          title: 'Login Failed',
          content:
              'Invalid username or password. Please check your credentials and try again.',
        );
      }
    } catch (e) {
      // Handle any errors during validation
      if (mounted) {
        customDialog(
          context,
          title: 'Login Error',
          content: 'An error occurred while logging in: ${e.toString()}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_TEXT_COLOR_WHITE,
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
                      SizedBox(height: ScreenUtil().setHeight(30)),
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
                      if (_errorMessage != null) ...[
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(15),
                            vertical: ScreenUtil().setHeight(10),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: ScreenUtil().setSp(20),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(10)),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: ScreenUtil().setSp(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: ScreenUtil().setHeight(50)),
                      CustomInkwellButton(
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