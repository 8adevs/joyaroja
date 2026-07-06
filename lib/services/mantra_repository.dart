import '../models/mantra.dart';

/// Source of truth for the fixed catalog of mantras and the logic that
/// picks which one is "active" today.
class MantraRepository {
  static const List<Mantra> mantras = [
    Mantra(id: 'mantra_1', titleKey: 'mantra_1_title', textKey: 'mantra_1_text'),
    Mantra(id: 'mantra_2', titleKey: 'mantra_2_title', textKey: 'mantra_2_text'),
    Mantra(id: 'mantra_3', titleKey: 'mantra_3_title', textKey: 'mantra_3_text'),
    Mantra(id: 'mantra_4', titleKey: 'mantra_4_title', textKey: 'mantra_4_text'),
    Mantra(id: 'mantra_5', titleKey: 'mantra_5_title', textKey: 'mantra_5_text'),
    Mantra(id: 'mantra_6', titleKey: 'mantra_6_title', textKey: 'mantra_6_text'),
    Mantra(id: 'mantra_7', titleKey: 'mantra_7_title', textKey: 'mantra_7_text'),
    Mantra(id: 'mantra_8', titleKey: 'mantra_8_title', textKey: 'mantra_8_text'),
    Mantra(id: 'mantra_9', titleKey: 'mantra_9_title', textKey: 'mantra_9_text'),
    Mantra(id: 'mantra_10', titleKey: 'mantra_10_title', textKey: 'mantra_10_text'),
  ];

  Mantra byId(String id) =>
      mantras.firstWhere((m) => m.id == id, orElse: () => mantras.first);

  /// Resolves the mantra to show today. When [random] is true, the pick
  /// is seeded by the calendar date so it stays the same all day and
  /// only changes once per day, rather than on every app open.
  Mantra mantraForToday({
    required bool random,
    required String fixedId,
    required DateTime date,
  }) {
    if (!random) return byId(fixedId);
    final daysSinceEpoch = date.difference(DateTime(2024, 1, 1)).inDays;
    final index = daysSinceEpoch % mantras.length;
    return mantras[index < 0 ? index + mantras.length : index];
  }
}
