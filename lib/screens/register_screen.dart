import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';
import 'package:tuazon_mobprog/widgets/custom_inkwell_button.dart';
import 'package:tuazon_mobprog/widgets/custom_textformfield.dart';
import 'package:tuazon_mobprog/widgets/custom_dialogs.dart';
import 'package:tuazon_mobprog/services/user_database.dart';

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
  final UserDatabase _userDatabase = UserDatabase();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Validate first name
  String? _validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid First Name',
        content: 'Please enter your first name.',
      );
      return 'First name is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      customDialog(
        context,
        title: 'Invalid First Name',
        content: 'First name should only contain letters.',
      );
      return 'First name should only contain letters';
    }
    if (value.trim().length < 2) {
      customDialog(
        context,
        title: 'Invalid First Name',
        content: 'First name must be at least 2 characters long.',
      );
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  // Validate last name
  String? _validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Last Name',
        content: 'Please enter your last name.',
      );
      return 'Last name is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      customDialog(
        context,
        title: 'Invalid Last Name',
        content: 'Last name should only contain letters.',
      );
      return 'Last name should only contain letters';
    }
    if (value.trim().length < 2) {
      customDialog(
        context,
        title: 'Invalid Last Name',
        content: 'Last name must be at least 2 characters long.',
      );
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  // Validate mobile number
  String? _validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Please enter your mobile number.',
      );
      return 'Mobile number is required';
    }
    final mobile = value.trim();
    if (mobile.length != 11) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Mobile number must be exactly 11 digits.',
      );
      return 'Mobile number must be 11 digits';
    }
    if (!RegExp(r'^09\d{9}$').hasMatch(mobile)) {
      customDialog(
        context,
        title: 'Invalid Mobile Number',
        content: 'Mobile number must start with 09 and contain only numbers.',
      );
      return 'Mobile number must start with 09';
    }
    return null;
  }

  // Validate username
  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Please enter a username.',
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
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      customDialog(
        context,
        title: 'Invalid Username',
        content: 'Username can only contain letters, numbers, and underscores.',
      );
      return 'Username contains invalid characters';
    }
    return null;
  }

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Please enter a password.',
      );
      return 'Password is required';
    }
    if (value.length < 8) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must be at least 8 characters long.',
      );
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one uppercase letter.',
      );
      return 'Password must contain uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one lowercase letter.',
      );
      return 'Password must contain lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one number.',
      );
      return 'Password must contain a number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      customDialog(
        context,
        title: 'Invalid Password',
        content: 'Password must contain at least one special character.',
      );
      return 'Password must contain a special character';
    }
    return null;
  }

  // Validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      customDialog(
        context,
        title: 'Invalid Confirm Password',
        content: 'Please confirm your password.',
      );
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      customDialog(
        context,
        title: 'Password Mismatch',
        content: 'Passwords do not match. Please try again.',
      );
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> register() async {
    // Validate all fields
    final firstNameError = _validateFirstName(firstNameController.text);
    if (firstNameError != null) return;

    final lastNameError = _validateLastName(lastNameController.text);
    if (lastNameError != null) return;

    final mobileError = _validateMobileNumber(mobilenumController.text);
    if (mobileError != null) return;

    final usernameError = _validateUsername(usernameController.text);
    if (usernameError != null) return;

    final passwordError = _validatePassword(passwordController.text);
    if (passwordError != null) return;

    final confirmPasswordError = _validateConfirmPassword(
      confirmpasswordController.text,
    );
    if (confirmPasswordError != null) return;

    // Save user to database
    final errorMessage = await _userDatabase.saveUser(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      mobileNumber: mobilenumController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    if (errorMessage == null) {
      // Success - no error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Show the specific error message using custom dialog
      if (mounted) {
        customDialog(
          context,
          title: 'Registration Failed',
          content: errorMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_TEXT_COLOR_WHITE,
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
              CustomFont(
                text: 'Register Here',
                fontSize: ScreenUtil().setSp(50),
                fontWeight: FontWeight.bold,
                color: FB_DARK_PRIMARY,
              ),
              SizedBox(height: ScreenUtil().setHeight(25)),
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
              Text(
                '(Password should be at least 8 characters, a mixture of letter and numbers consisting of at least one special character with Uppercase and Lowercase letters.)',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: ScreenUtil().setSp(10),
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
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have an account? ',
                    style: TextStyle(
                      color: Colors.black45,
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
              CustomInkwellButton(
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
