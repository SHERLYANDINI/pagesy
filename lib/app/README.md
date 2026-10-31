# app/

Konfigurasi level aplikasi, bukan logika fitur.

## Isi
| File | Fungsi |
|------|--------|
| `app.dart` | Widget root: `MaterialApp.router`, theme, localization |
| `router.dart` | Definisi route (go_router), redirect auth guard |

## Aturan
- Boleh meng-import dari `core/` dan `features/*/presentation/pages`.
- Jangan taruh logika bisnis atau panggilan API di sini.
