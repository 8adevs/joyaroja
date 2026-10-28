import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fonts are bundled in assets/google_fonts/; never hit the network.
  GoogleFonts.config.allowRuntimeFetching = false;
  _registerFontLicenses();
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

/// Both bundled fonts are SIL OFL 1.1, which requires shipping the license.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in const [
      ('Inter', 'OFL-Inter.txt'),
      ('Playfair Display', 'OFL-PlayfairDisplay.txt'),
    ]) {
      final text = await rootBundle.loadString('assets/google_fonts/$file');
      yield LicenseEntryWithLineBreaks([family], text);
    }
  });
}
