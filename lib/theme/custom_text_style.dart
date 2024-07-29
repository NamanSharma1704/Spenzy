import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeWhiteA700 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.whiteA700,
      );
  static get bodyMediumYellow50 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.yellow50,
      );
  static get bodySmallJura => theme.textTheme.bodySmall!.jura.copyWith(
        fontSize: 14.5.fSize,
      );
  // Display text style
  static get displayMediumWallpoet =>
      theme.textTheme.displayMedium!.wallpoet.copyWith(
        fontSize: 50.fSize,
      );
}

extension on TextStyle {
  TextStyle get wallpoet {
    return copyWith(
      fontFamily: 'Wallpoet',
    );
  }

  TextStyle get jura {
    return copyWith(
      fontFamily: 'Jura',
    );
  }
}
