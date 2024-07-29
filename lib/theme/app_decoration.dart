import 'package:flutter/material.dart';
import 'package:spenzy/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray900,
      );

  // Outline decorations
  static BoxDecoration get outlineBlackF => BoxDecoration();
  static BoxDecoration get outlineTealA => BoxDecoration(
        color: appTheme.gray900.withOpacity(0.7),
        border: Border.all(
          color: appTheme.tealA400,
          width: 1.h,
        ),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder59 => BorderRadius.circular(
        59.h,
      );

  // Rounded borders
  static BorderRadius get roundedBorder13 => BorderRadius.circular(
        13.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
