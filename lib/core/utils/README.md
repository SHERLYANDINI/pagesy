# core/utils/

Helper kecil dan murni (tanpa state, tanpa UI).

## Contoh isi
- `formatters.dart` : format tanggal, angka, mata uang
- `validators.dart` : validasi form (email, wajib isi)
- `extensions.dart` : extension pada `String`, `DateTime`, `BuildContext`

## Aturan
- Satu file = satu tema. Hindari file `utils.dart` raksasa.
- Kalau helper hanya dipakai satu fitur, pindahkan ke fitur itu.
