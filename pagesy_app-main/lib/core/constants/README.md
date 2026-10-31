# core/constants/

Nilai tetap yang dipakai di banyak tempat.

## Contoh isi
- `api_constants.dart` : base URL Laravel, path endpoint dasar, timeout
- `storage_keys.dart` : key untuk secure storage (misal `auth_token`)
- `app_constants.dart` : nilai umum (page size, durasi animasi)

## Catatan
- Pisahkan base URL per environment (dev/staging/prod), misalnya lewat `--dart-define`.
- Jangan hardcode secret/API key sensitif di sini.
