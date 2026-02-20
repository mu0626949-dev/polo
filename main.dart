import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:polo/pages/home_page.dart' hide App;
import 'app.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => App(),
    ),
  );
}
