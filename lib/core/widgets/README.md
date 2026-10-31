# core/widgets/

Widget UI **reusable lintas fitur**.

## Contoh isi
- `app_button.dart`, `app_text_field.dart`
- `loading_indicator.dart`, `error_view.dart`, `empty_view.dart`

## Aturan
- Widget bersifat generik: terima data dan callback lewat parameter, tidak memanggil repository/state fitur.
- Widget khusus satu fitur taruh di `features/<fitur>/presentation/widgets/`.
