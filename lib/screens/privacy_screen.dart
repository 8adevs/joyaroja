import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Public contact shown in the policy; must match the Play Store listing
/// and the web version published on GitHub Pages.
const kContactEmail = 'joyaroja.app@gmail.com';
const kPrivacyPolicyUrl =
    'https://8adevs.github.io/joyaroja/privacy.html';

/// In-app copy of the privacy policy. Google Play requires the policy to be
/// reachable inside the app (link or text); showing the text avoids adding
/// a url_launcher dependency.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = {'email': kContactEmail, 'url': kPrivacyPolicyUrl};

    return Scaffold(
      appBar: AppBar(title: Text('privacy.title'.tr())),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text('privacy.updated'.tr(), style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            SelectableText(
              'privacy.body'.tr(namedArgs: args),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
