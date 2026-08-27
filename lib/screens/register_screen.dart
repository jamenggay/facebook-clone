import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/widgets/custom_inkwell_button.dart';
import 'package:tuazon_mobprog/widgets/custom_textformfield.dart';
import 'package:tuazon_mobprog/widgets/custom_dialogs.dart';
import 'package:tuazon_mobprog/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobilenumController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final UserService _userService = UserService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobilenumController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobile = mobilenumController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmpasswordController.text;

    if (firstName.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(firstName)) {
      customDialog(
        context,
        title: 'Invalid First Name',
        content: 'Please enter a first name that only contains letters.',
      );
      return false;
    }
    if (lastName.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(lastName)) {
      customDialog(
        context,
        title: 'Invalid Last Name',
        content: 'Please enter a last name that only contains letters.',
      );
      return false;
    }
    if (!RegExp(r'^09\d{9}$').hasMatch(mobile)) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Mobile number must be 11 digits and start with 09.',
      );
      return false;
    }
    if (username.length < 3 || !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      customDialog(
        context,
        title: 'Invalid Username',
        content:
            'Username must be at least 3 characters and can only contain '
            'letters, numbers and underscores.',
      );
      return false;
    }
    if (password.length < 8) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must be at least 8 characters long.',
      );
      return false;
    }
    if (password != confirmPassword) {
      customDialog(
        context,
        title: 'Password Mismatch',
        content: 'Passwords do not match. Please try again.',
      );
      return false;
    }
    return true;
  }

  Future<void> register() async {
    if (!_isFormValid()) return;

    setState(() => _isLoading = true);

    final errorMessage = await _userService.register(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone: mobilenumController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      customDialog(
        context,
        title: 'Registration Failed',
        content: errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_SURFACE,
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(40),
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(10),
          ),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(25)),
              Image.asset(
                'assets/images/chatbubble.png',
                height: ScreenUtil().setHeight(155),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Register',
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
                onSaved: null,
                fontColor: null,
                hintText: 'First Name',
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: firstNameController,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomTextFormField(
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                hintText: 'Last Name',
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: lastNameController,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomTextFormField(
                maxLength: 11,
                keyboardType: TextInputType.number,
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                hintText: 'Mobile Number',
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: mobilenumController,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomTextFormField(
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                hintText: 'Username',
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: usernameController,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomTextFormField(
                isObscure: _obscurePassword,
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                hintText: 'Password',
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: passwordController,
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
              CustomTextFormField(
                isObscure: _obscureConfirmPassword,
                hintText: 'Confirm Password',
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                onSaved: null,
                fontColor: null,
                validator: (value) => null,
                hintTextSize: ScreenUtil().setSp(15),
                fontSize: ScreenUtil().setSp(15),
                controller: confirmpasswordController,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: FB_PRIMARY,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have an account? ',
                    style: TextStyle(
                      color: FB_TEXT_COLOR_GREY,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.popAndPushNamed(context, '/login'),
                    child: Text(
                      'Login here',
                      style: TextStyle(
                        color: FB_DARK_PRIMARY,
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _isLoading
                  ? SizedBox(
                      height: ScreenUtil().setHeight(45),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: FB_LIGHT_PRIMARY,
                        ),
                      ),
                    )
                  : CustomInkwellButton(
                      onTap: () async => await register(),
                      height: ScreenUtil().setHeight(45),
                      width: ScreenUtil().screenWidth,
                      fontSize: ScreenUtil().setSp(15),
                      fontWeight: FontWeight.bold,
                      buttonName: 'Submit',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
