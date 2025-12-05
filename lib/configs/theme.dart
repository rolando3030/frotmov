import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffff7f2a),
      surfaceTint: Color(0xffff7f2a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdbca),
      onPrimaryContainer: Color(0xffececec),
      secondary: Color(0xff765848),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdbca),
      onSecondaryContainer: Color(0xff5c4132),
      tertiary: Color(0xff006874),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9eeffd),
      onTertiaryContainer: Color(0xff004f58),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff221a15),
      onSurfaceVariant: Color(0xff52443d),
      outline: Color(0xff85746b),
      outlineVariant: Color(0xffd7c2b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68f),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff331200),
      primaryFixedDim: Color(0xffffb68f),
      onPrimaryFixedVariant: Color(0xffececec),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff2b160a),
      secondaryFixedDim: Color(0xffe6beab),
      onSecondaryFixedVariant: Color(0xff5c4132),
      tertiaryFixed: Color(0xff9eeffd),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xff82d3e0),
      onTertiaryFixedVariant: Color(0xff004f58),
      surfaceDim: Color(0xffe8d7cf),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfffceae3),
      surfaceContainerHigh: Color(0xfff6e5dd),
      surfaceContainerHighest: Color(0xfff0dfd7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5b2705),
      surfaceTint: Color(0xffff7f2a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9e5c36),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4a3022),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff866656),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003c44),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff187884),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff170f0b),
      onSurfaceVariant: Color(0xff41332d),
      outline: Color(0xff5f4f48),
      outlineVariant: Color(0xff7a6a62),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68f),
      primaryFixed: Color(0xff9e5c36),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff814521),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff866656),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6b4e3f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff187884),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff005e68),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd4c3bc),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfff6e5dd),
      surfaceContainerHigh: Color(0xffead9d2),
      surfaceContainerHighest: Color(0xffdfcec7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4d1e00),
      surfaceTint: Color(0xffff7f2a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff723a16),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3e2619),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5f4334),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003238),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00515a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff362923),
      outlineVariant: Color(0xff55463f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68f),
      primaryFixed: Color(0xff723a16),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff562402),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5f4334),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff462d1f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00515a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00393f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5b6af),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede5),
      surfaceContainer: Color(0xfff0dfd7),
      surfaceContainerHigh: Color(0xffe2d1ca),
      surfaceContainerHighest: Color(0xffd4c3bc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb68f),
      surfaceTint: Color(0xffffb68f),
      onPrimary: Color(0xff532201),
      primaryContainer: Color(0xff703714),
      onPrimaryContainer: Color(0xffffdbca),
      secondary: Color(0xffe6beab),
      onSecondary: Color(0xff432b1d),
      secondaryContainer: Color(0xff5c4132),
      onSecondaryContainer: Color(0xffffdbca),
      tertiary: Color(0xff82d3e0),
      onTertiary: Color(0xff00363d),
      tertiaryContainer: Color(0xff004f58),
      onTertiaryContainer: Color(0xff9eeffd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a120d),
      onSurface: Color(0xfff0dfd7),
      onSurfaceVariant: Color(0xffd7c2b9),
      outline: Color(0xff9f8d84),
      outlineVariant: Color(0xff52443d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xffff7f2a),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff331200),
      primaryFixedDim: Color(0xffffb68f),
      onPrimaryFixedVariant: Color(0xff703714),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff2b160a),
      secondaryFixedDim: Color(0xffe6beab),
      onSecondaryFixedVariant: Color(0xff5c4132),
      tertiaryFixed: Color(0xff9eeffd),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xff82d3e0),
      onTertiaryFixedVariant: Color(0xff004f58),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff413732),
      surfaceContainerLowest: Color(0xff140c09),
      surfaceContainerLow: Color(0xff221a15),
      surfaceContainer: Color(0xff271e19),
      surfaceContainerHigh: Color(0xff322823),
      surfaceContainerHighest: Color(0xff3d332e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd3bd),
      surfaceTint: Color(0xffffb68f),
      onPrimary: Color(0xff431900),
      primaryContainer: Color(0xffc87f56),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffdd4c0),
      onSecondary: Color(0xff372013),
      secondaryContainer: Color(0xffac8977),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff98e9f7),
      onTertiary: Color(0xff002a30),
      tertiaryContainer: Color(0xff499ca9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a120d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffeed8ce),
      outline: Color(0xffc2aea5),
      outlineVariant: Color(0xff9f8d84),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff713915),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff230a00),
      primaryFixedDim: Color(0xffffb68f),
      onPrimaryFixedVariant: Color(0xff5b2705),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff1f0c03),
      secondaryFixedDim: Color(0xffe6beab),
      onSecondaryFixedVariant: Color(0xff4a3022),
      tertiaryFixed: Color(0xff9eeffd),
      onTertiaryFixed: Color(0xff001417),
      tertiaryFixedDim: Color(0xff82d3e0),
      onTertiaryFixedVariant: Color(0xff003c44),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff4d423d),
      surfaceContainerLowest: Color(0xff0c0604),
      surfaceContainerLow: Color(0xff241c17),
      surfaceContainer: Color(0xff2f2621),
      surfaceContainerHigh: Color(0xff3b302c),
      surfaceContainerHighest: Color(0xff463b36),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece4),
      surfaceTint: Color(0xffffb68f),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb186),
      onPrimaryContainer: Color(0xff190600),
      secondary: Color(0xffffece4),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe2bba7),
      onSecondaryContainer: Color(0xff180701),
      tertiary: Color(0xffcdf7ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff7ecfdc),
      onTertiaryContainer: Color(0xff000e10),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1a120d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece4),
      outlineVariant: Color(0xffd3beb5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff713915),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb68f),
      onPrimaryFixedVariant: Color(0xff230a00),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe6beab),
      onSecondaryFixedVariant: Color(0xff1f0c03),
      tertiaryFixed: Color(0xff9eeffd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff82d3e0),
      onTertiaryFixedVariant: Color(0xff001417),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff594e48),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff271e19),
      surfaceContainer: Color(0xff382e29),
      surfaceContainerHigh: Color(0xff443934),
      surfaceContainerHighest: Color(0xff50443f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
