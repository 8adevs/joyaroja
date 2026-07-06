import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Heavy initialisation (timezone DB + notification plugin) is now done
  // inside SplashScreen, AFTER the first frame renders.  This prevents the
  // main thread from blocking before runApp(), which was causing ANR on
  // slow Android devices.
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('es'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      child: const ProviderScope(child: MantraApp()),
    ),
  );
}
