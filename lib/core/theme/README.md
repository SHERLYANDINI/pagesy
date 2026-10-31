# core/theme/

Identitas visual aplikasi.

## Isi (contoh)
- `app_theme.dart` : `ThemeData` light/dark
- `app_colors.dart` : palet warna
- `app_text_styles.dart` : gaya teks
- `app_spacing.dart` : konstanta jarak/radius

## Aturan
- Widget mengambil warna/teks dari `Theme.of(context)` atau konstanta di sini, bukan hardcode nilai.
