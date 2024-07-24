// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, unnecessary_import

import 'dart:ui';
import 'package:chat_app/components/square_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';



class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void login(BuildContext context) async {
    final authservice = Authservice();

    try {
      await authservice.signInWithEmailPassword(
        _emailController.text,
        _pwdController.text, 
        _nameController.text
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset('images/chrome_butterfly_background.png'),
                ),
                const SizedBox(height: 25),
                Text(
                  "Welcome to Valentine!!",
                  style: GoogleFonts.dmSerifDisplay(textStyle: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 25),
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
                const SizedBox(height: 25),
                MyButton(
                  text: "Login",
                  onTap: () => login(context),
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?", style: TextStyle(color: Theme.of(context).colorScheme.background)),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        )
                      ),
                      Text("or log in with"),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      imagePath: 'images/Logo-google-icon-PNG-removebg-preview.png', 
                      onTap: () => Authservice().signInWithGoogle(),
                    ),
                    SizedBox(width: 10),
                    SquareTile(
                      imagePath: 'images/png-transparent-apple-logo-apple-logo-removebg-preview.png', 
                      onTap: () => {},
                    ),
                  ],
                )
              ],
            ),
          ),
      );
  }
}
