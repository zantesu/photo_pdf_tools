import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';

const _seedColor = Color(0xFF3D7EFF);

final lightTheme = _createTheme(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  ),
).useSystemChineseFont(Brightness.light);

final darkTheme = _createTheme(
  colorScheme: ColorScheme.fromSeed(
    dynamicSchemeVariant: DynamicSchemeVariant.content,
    seedColor: _seedColor,
    brightness: Brightness.dark,
  ),
).useSystemChineseFont(Brightness.dark);

ThemeData _createTheme({required ColorScheme colorScheme}) {
  return ThemeData(
    colorScheme: colorScheme,

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: colorScheme.onSurface,
      toolbarHeight: 64,
      iconTheme: IconThemeData(color: colorScheme.secondary),
      titleTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 18),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.onInverseSurface,
      modalBackgroundColor: colorScheme.onInverseSurface,
      surfaceTintColor: colorScheme.onInverseSurface,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.onInverseSurface,
      surfaceTintColor: colorScheme.onInverseSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    cardTheme: CardThemeData(
      clipBehavior: Clip.hardEdge,
      color: colorScheme.onInverseSurface,
    ),

    chipTheme: ChipThemeData(
      showCheckmark: false,
      side: BorderSide.none,
      backgroundColor: colorScheme.surfaceContainer,
    ),

    dividerTheme: const DividerThemeData(thickness: 0, space: 0),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colorScheme.primary, width: 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      filled: true,
      fillColor: colorScheme.onInverseSurface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      hintStyle: TextStyle(color: colorScheme.outline, fontSize: 15),
      labelStyle: TextStyle(color: colorScheme.outline, fontSize: 15),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onSecondaryContainer,
      textColor: colorScheme.onSecondaryContainer,
    ),

    //textTheme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        color: colorScheme.outline,
        fontWeight: FontWeight.normal,
      ),
      labelMedium: TextStyle(
        color: colorScheme.outline,
        fontWeight: FontWeight.normal,
      ),
      labelSmall: TextStyle(
        color: colorScheme.outline,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      bodyMedium: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      bodySmall: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
    ),
  );
}
