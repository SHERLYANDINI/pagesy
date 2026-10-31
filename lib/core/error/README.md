# core/error/

Penyeragaman error supaya UI tidak perlu tahu detail Dio atau format error Laravel.

## Isi
- `app_exception.dart` : kelas error aplikasi, misalnya `NetworkException`, `UnauthorizedException`, `ValidationException`, `ServerException`

## Pemetaan error Laravel
| Response | Jadi |
|----------|------|
| timeout / tanpa koneksi | `NetworkException` |
| 401 | `UnauthorizedException` |
| 422 (`errors` per field) | `ValidationException` (simpan map field → pesan) |
| 5xx | `ServerException` |

## Aturan
- Konversi `DioException → AppException` dilakukan di **repository**.
- UI hanya menampilkan `message` dari `AppException`.
