import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:polo/pages/home_page1.dart';
import 'package:polo/pages/home_page3.dart';
import 'package:polo/pages/home_page2.dart';
import 'package:polo/pages/home_page4.dart';
import 'package:polo/pages/login_page1.dart';
import 'package:polo/pages/login_page2.dart';
import 'package:polo/pages/map_page.dart';
import 'package:polo/pages/my_refresh_page.dart';
import 'package:polo/pages/page_1.dart';
import 'package:polo/pages/users_page.dart';
import 'package:polo/pages/video_screen.dart';
import 'package:polo/pages/working_page.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      home: UsersPage(),
    );
  }
}
