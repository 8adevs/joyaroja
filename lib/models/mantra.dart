/// A mantra the user can repeat during a session.
///
/// [titleKey] and [textKey] are easy_localization keys, except for
/// custom mantras (future feature) where [isCustom] is true and the
/// content is stored directly in [customTitle]/[customText] instead.
class Mantra {
  const Mantra({
    required this.id,
    this.titleKey,
    this.textKey,
    this.isCustom = false,
    this.customTitle,
    this.customText,
  });

  final String id;
  final String? titleKey;
  final String? textKey;
  final bool isCustom;
  final String? customTitle;
  final String? customText;
}
