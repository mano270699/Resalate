import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveUtils {
  static const double mobileLayoutWidth = 600.0;
  
  /// Checks if the current device is a tablet.
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileLayoutWidth;
  }

  /// Use this to cap max width dynamically if not using ConstrainedBox
  static double get maxWidth {
    return mobileLayoutWidth;
  }

  /// Capped sizing for height
  static double cappedHeight(double height) {
    return min(height.h, height * 1.5); // Example scaling limit
  }

  /// Capped sizing for widths on things like buttons
  static double cappedWidth(double width) {
    return min(width.w, width * 1.5);
  }
}
