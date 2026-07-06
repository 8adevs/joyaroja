import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mantra.dart';
import '../providers/settings_provider.dart';
import '../services/mantra_repository.dart';

class MantrasScreen extends ConsumerWidget {
  const MantrasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final randomActive = settings.randomDailyMantra;

    return Scaffold(
      appBar: AppBar(title: Text('mantras.title'.tr())),
      body: Column(
        children: [
          if (randomActive)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Text(
                'mantras.random_active_notice'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          Expanded(
            child: Opacity(
              opacity: randomActive ? 0.45 : 1,
              child: IgnorePointer(
                ignoring: randomActive,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: MantraRepository.mantras.length,
                  itemBuilder: (context, index) {
                    final mantra = MantraRepository.mantras[index];
                    final selected = mantra.id == settings.selectedMantraId;
                    return _MantraCard(
                      mantra: mantra,
                      selected: selected,
                      onTap: () => ref
                          .read(settingsProvider.notifier)
                          .setSelectedMantra(mantra.id),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MantraCard extends StatelessWidget {
  const _MantraCard({
    required this.mantra,
    required this.selected,
    required this.onTap,
  });

  final Mantra mantra;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: selected
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mantra.titleKey!.tr(), style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      mantra.textKey!.tr(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
