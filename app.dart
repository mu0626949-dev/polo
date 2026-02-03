import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:polocha/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
