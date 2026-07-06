// ignore_for_file: directives_ordering
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../theme/app_colors.dart';
import '../widgets/jewel_widget.dart';
import '../widgets/glowing_text.dart';

// ---------------------------------------------------------------------------
// Flutter Widget Previewer — requiere Flutter 3.35+
// Ejecutar desde terminal:  flutter widget-preview start
// En VS Code / Android Studio 3.38+: panel "Flutter Widget Preview" lateral
// ---------------------------------------------------------------------------

@Preview(name: 'Joya – reposo (dark)', brightness: Brightness.dark)
Widget jewelRestDark() => _darkScaffold(const JewelWidget(isActive: false));

@Preview(name: 'Joya – activa (dark)', brightness: Brightness.dark)
Widget jewelActiveDark() => _darkScaffold(const JewelWidget(isActive: true));

@Preview(name: 'Joya – reposo (light)', brightness: Brightness.light)
Widget jewelRestLight() => _lightScaffold(const JewelWidget(isActive: false));

@Preview(name: 'GlowingText – dark', brightness: Brightness.dark)
Widget glowingTextDark() => _darkScaffold(
      const GlowingText(
        text: 'Soy un imán para la abundancia',
        color: AppColors.jewelCore,
      ),
    );

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _darkScaffold(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: AppColors.midnightBackground,
        body: Center(child: child),
      ),
    );

Widget _lightScaffold(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: AppColors.ivoryBackground,
        body: Center(child: child),
      ),
    );
