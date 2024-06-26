// ignore_for_file: camel_case_types

import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';

class loginOrRegister extends StatefulWidget {
  const loginOrRegister({super.key});

  @override
  State<loginOrRegister> createState() => loginOrRegisterState();
}

class loginOrRegisterState extends State<loginOrRegister> {
  bool showLoginPage = true;
  void togglePage(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(
        onTap: togglePage,
      );
    }
    else{
      return RegisterPage(
        onTap: togglePage,
      );
    }
  }
}