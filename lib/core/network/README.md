# core/network/

Semua yang berkaitan dengan koneksi ke API Laravel.

## Isi
| File | Fungsi |
|------|--------|
| `dio_client.dart` | Instance Dio: base URL, timeout, header default (`Accept: application/json`) |
| `auth_interceptor.dart` | Pasang token `Authorization: Bearer ...`, tangani 401 (logout/refresh) |

## Aturan
- Satu instance Dio untuk seluruh app, di-inject ke repository.
- Repository yang memanggil Dio. Widget/state **tidak** boleh memanggil Dio langsung.
- Logging hanya aktif di mode debug.
