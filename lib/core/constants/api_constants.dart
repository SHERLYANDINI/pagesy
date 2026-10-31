class ApiConstants {
  // Emulator Android: 10.0.2.2 = localhost laptop.
  // HP fisik: ganti dengan IP laptop, mis. http://192.168.1.10:8000/api
  // Bisa dioverride: flutter run --dart-define=BASE_URL=https://api.example.com/api
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 15);
}
