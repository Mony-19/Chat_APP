// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks
import 'dart:ui';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  final void Function()? onTap;

 RegisterPage({super.key, required this.onTap});

 void register(BuildContext context){
  final _auth = Authservice();
  if (_pwdController.text == _confirmPwdController.text){
    try {
      _auth.signUpWithEmailPassword(
        _emailController.text, 
        _pwdController.text);
    } catch (e) {
       showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
       )
      );
    }
  }else{
    showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Your Password don't match"),
       ),
    );
  }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/butterfly_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.2), // Adjust opacity as needed
            ),
          ),
          Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //icon
              ImageIcon(
                  AssetImage(
                    'images/chrome_butterfly_background.png',
                    ),
                    size: 55,
                    color: Colors.white,
              ),
              const SizedBox(height: 50),
              //Text
              Text(
                "Let's create an account for you",
                style: GoogleFonts.dmSerifDisplay(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20)),
              ),
              const SizedBox(height: 25),
              //email textfield
              MyTextField(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Password',
                obscureText: true,
                controller: _pwdController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Confirm your Password',
                obscureText: true,
                controller: _confirmPwdController,
              ),
              const SizedBox(height: 25),
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("already have an account?", 
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary
                    )
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    " Login Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ],)
            ],
          ),
        ),
        ]
      ),
    );
  }
}