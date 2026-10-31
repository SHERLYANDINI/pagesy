# core/storage/

Penyimpanan data lokal.

## Isi (contoh)
- `secure_storage.dart` : wrapper `flutter_secure_storage` untuk token
- `preferences.dart` : wrapper `shared_preferences` untuk setting non-sensitif (tema, bahasa)

## Aturan
- Token/credential **wajib** di secure storage, bukan SharedPreferences.
- Bungkus package dalam class sendiri agar gampang diganti dan di-mock saat test.
