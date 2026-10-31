import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Warna utama
  static const Color _primary = Color(0xFFA33C14);
  static const Color _dark = Color(0xFF1F1A17);
  static const Color _fieldFill = Color(0xFFF4EEE8);
  static const Color _fieldBorder = Color(0xFFE6DDD3);

  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: const Color(0xFF9A918A),
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF4A423D), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: border(_fieldBorder),
      enabledBorder: border(_fieldBorder),
      focusedBorder: border(_primary, 1.5),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _dark,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Background gradasi putih -> peach tipis
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFDF3EC), Color(0xFFFBE9DD)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Semburat hijau tipis di kiri
            Positioned(
              left: -120,
              top: 220,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFDDEFD9).withAlpha(120),
                      const Color(0xFFDDEFD9).withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
            // Semburat peach di kanan atas
            Positioned(
              right: -120,
              top: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFCE3D3).withAlpha(150),
                      const Color(0xFFFCE3D3).withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildFormCard(),
                      const SizedBox(height: 28),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F2EC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3DDD6)),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            // Ganti dengan logo aslimu: assets/images/logo.png
            // (daftarkan di pubspec.yaml). Kalau belum ada, tampil ikon.
            child: Image.asset(
              'assets/images/logo.png',
              width: 34,
              height: 34,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.auto_stories_rounded,
                color: _primary,
                size: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Branding "Pagesy •"
        Text.rich(
          TextSpan(
            text: 'Pagesy ',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _primary,
            ),
            children: const [
              TextSpan(
                text: '•',
                style: TextStyle(color: Color(0xFFD9481F)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Judul
        Text(
          'Nyalakan Kembali\nSemangat Membacamu',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: _dark,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),

        // Subtitle
        Text(
          'Masuk ke akunmu untuk melanjutkan streak\nmembaca buku favoritmu',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: const Color(0xFF5E5650),
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(235),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFEFE8E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withAlpha(30),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Email atau Nama Pengguna'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
              decoration: _inputDecoration(
                hint: 'nama@email.com',
                icon: Icons.mail_outline,
              ),
            ),
            const SizedBox(height: 16),

            _label('Kata Sandi'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
              decoration: _inputDecoration(
                hint: '••••••••',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF4A423D),
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Ingat saya & Lupa kata sandi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 22,
                      width: 22,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: _primary,
                        side: const BorderSide(color: Color(0xFF8A817A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (v) =>
                            setState(() => _rememberMe = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ingat saya',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF4A423D),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: aksi Lupa Kata Sandi
                  },
                  child: Text(
                    'Lupa Kata Sandi?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Tombol masuk
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: proses login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Masuk ke Pagesy',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum punya akun Pagesy? ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF5E5650),
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Daftar sekarang',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Pagesy • Ruang Tenang Para Pembaca',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: const Color(0xFF9A918A),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
