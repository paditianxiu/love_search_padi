import 'package:flutter/material.dart';
import './MyApp.dart';
// ignore: depend_on_referenced_packages
import 'package:media_kit/media_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}
