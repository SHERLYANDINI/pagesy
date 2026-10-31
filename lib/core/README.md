# core/

Kode yang **benar-benar dipakai lintas fitur**. Kalau hanya dipakai satu fitur, taruh di fitur itu.

## Sub-folder
- `constants/` : base URL, key, nilai tetap
- `network/` : Dio client dan interceptor
- `error/` : exception/failure yang seragam
- `storage/` : penyimpanan lokal (token, preferensi)
- `theme/` : warna, typography, ThemeData
- `utils/` : helper kecil (formatter, validator, extension)
- `widgets/` : widget UI yang dipakai banyak fitur

## Aturan
- `core/` **tidak boleh** meng-import dari `features/`.
- Jangan jadikan `core/` tempat sampah. Tiap file harus punya alasan dipakai minimal 2 fitur.
