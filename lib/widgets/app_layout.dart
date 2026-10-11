import 'package:flutter/material.dart';

abstract final class AppLayout {
  static const navigationBreakpoint = 900.0;
  static const expandedNavigationBreakpoint = 1280.0;
  static const playbackBreakpoint = 1100.0;
  static const contentMaxWidth = 1440.0;
  static const playbackMaxWidth = 1920.0;

  static EdgeInsets contentPadding(double width) =>
      EdgeInsets.all(width >= navigationBreakpoint ? 24 : 12);
}
