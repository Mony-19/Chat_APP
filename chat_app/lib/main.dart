// ignore_for_file: unused_import, prefer_const_constructors

import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/services/auth/login_or_register.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:device_preview/device_preview.dart';
void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DevicePreview(
      enabled: true,
      builder: (context) => const ChatApp(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: lightMode,
    );
  }
}