import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mantra.dart';
import '../services/mantra_repository.dart';
import 'settings_provider.dart';

final mantraRepositoryProvider = Provider<MantraRepository>((ref) {
  return MantraRepository();
});

/// The mantra to show/use today, resolved from settings (fixed
/// selection vs. random-daily mode).
final activeMantraProvider = Provider<Mantra>((ref) {
  final settings = ref.watch(settingsProvider);
  final repository = ref.watch(mantraRepositoryProvider);
  return repository.mantraForToday(
    random: settings.randomDailyMantra,
    fixedId: settings.selectedMantraId,
    date: DateTime.now(),
  );
});
