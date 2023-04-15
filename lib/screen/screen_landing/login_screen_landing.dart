import 'package:flutter/material.dart';

import '../responsive_layout.dart';
import '../small_screen/login/login_screen.dart';



class LoginScreenLanding extends StatelessWidget {
  const LoginScreenLanding({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: LoginScreen(),
        tabletBody:  LoginScreen());
  }
}