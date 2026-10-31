import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Warna
  static const Color _bg = Color(0xFFFBF7F2);
  static const Color _primary = Color(0xFFC4532B);
  static const Color _linkColor = Color(0xFF9C3F1B);
  static const Color _dark = Color(0xFF1F1A17);
  static const Color _muted = Color(0xFF6B635C);
  static const Color _fieldFill = Color(0xFFF1EBE4);
  static const Color _fieldBorder = Color(0xFFE6DDD3);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreed = false;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()
      ..onTap = () {
        // TODO: buka halaman Ketentuan Layanan
      };
    _privacyTap = TapGestureRecognizer()
      ..onTap = () {
        // TODO: buka halaman Kebijakan Privasi
      };
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  // ---------- Kekuatan sandi: 0 = kosong, 1 = lemah, 2 = sedang, 3 = kuat ----------
  int get _strength {
    final p = _passwordController.text;
    if (p.isEmpty) return 0;
    int score = 1;
    if (p.length >= 8) score = 2;
    final hasMix = RegExp(r'[A-Z]').hasMatch(p) &&
        RegExp(r'[a-z]').hasMatch(p) &&
        RegExp(r'\d').hasMatch(p);
    final hasSymbol = RegExp(r'[^A-Za-z0-9]').hasMatch(p);
    if (p.length >= 8 && hasMix && hasSymbol) score = 3;
    return score;
  }

  String get _strengthLabel =>
      const ['Belum terisi', 'Lemah', 'Sedang', 'Kuat'][_strength];

  Color get _strengthColor {
    switch (_strength) {
      case 1:
        return const Color(0xFFD64545);
      case 2:
        return const Color(0xFFE59A2E);
      case 3:
        return const Color(0xFF3E9B5B);
      default:
        return const Color(0xFFE3DCD3);
    }
  }

  // ---------- Helper UI ----------
  InputDecoration _decoration({
    required String hint,
    required Widget suffix,
  }) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9A918A), fontSize: 14),
      suffixIcon: suffix,
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: border(_fieldBorder),
      enabledBorder: border(_fieldBorder),
      focusedBorder: border(_primary, 1.5),
      errorBorder: border(const Color(0xFFD64545)),
      focusedErrorBorder: border(const Color(0xFFD64545), 1.5),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: _dark,
        ),
      );

  Widget _icon(IconData icon) =>
      Icon(icon, color: const Color(0xFF6B635C), size: 20);

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Setujui Ketentuan Layanan dan Kebijakan Privasi dulu ya.'),
        ),
      );
      return;
    }
    // TODO: proses register di sini
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 28),

                // Judul
                const Text(
                  'Mulai Petualangan\nMembacamu',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontFamilyFallback: ['Times New Roman', 'serif'],
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Buat akun gratis dan bergabunglah dengan ribuan\npembaca setia lainnya.',
                  style: TextStyle(fontSize: 14, color: _muted, height: 1.4),
                ),
                const SizedBox(height: 24),

                // Nama lengkap
                _label('Nama Lengkap'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _decoration(
                    hint: 'contoh: Bima Arya',
                    suffix: _icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama lengkap wajib diisi'
                      : null,
                ),
                const SizedBox(height: 18),

                // Email
                _label('Alamat Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration(
                    hint: 'nama@email.com',
                    suffix: _icon(Icons.mail_outline),
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Email wajib diisi';
                    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                    return ok ? null : 'Format email tidak valid';
                  },
                ),
                const SizedBox(height: 18),

                // Kata sandi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _label('Kata Sandi'),
                    const Text(
                      'Min. 8 karakter',
                      style: TextStyle(fontSize: 12, color: _muted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _decoration(
                    hint: 'Minimal 8 karakter',
                    suffix: IconButton(
                      icon: _icon(_obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 8)
                      ? 'Kata sandi minimal 8 karakter'
                      : null,
                ),
                const SizedBox(height: 10),
                _buildStrengthMeter(),
                const SizedBox(height: 18),

                // Konfirmasi kata sandi
                _label('Konfirmasi Kata Sandi'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: _decoration(
                    hint: 'Ulangi kata sandi',
                    suffix: IconButton(
                      icon: _icon(_obscureConfirm
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) => v != _passwordController.text
                      ? 'Kata sandi tidak sama'
                      : null,
                ),
                const SizedBox(height: 20),

                _buildTerms(),
                const SizedBox(height: 20),

                // Tombol
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_fire_department_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Buat Akun Pagesy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sudah punya akun
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: TextStyle(fontSize: 13, color: _muted),
                        children: [
                          TextSpan(
                            text: 'Masuk',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _linkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.maybePop(context),
            customBorder: const CircleBorder(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EBE4),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE6DDD3)),
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: _dark),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F1EA),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE6DDD3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ganti dengan logo asli: Image.asset('assets/images/logo.png', width: 18)
              Image.asset(
                'assets/images/logo.png',
                width: 18,
                height: 18,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.auto_stories_rounded,
                  size: 18,
                  color: _primary,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Pagesy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _linkColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthMeter() {
    return Column(
      children: [
        Row(
          children: List.generate(3, (i) {
            final active = i < _strength;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                decoration: BoxDecoration(
                  color: active ? _strengthColor : const Color(0xFFE3DCD3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kekuatan Sandi',
              style: TextStyle(fontSize: 11, color: _muted),
            ),
            Text(
              _strengthLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _strength == 0 ? _dark : _strengthColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTerms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreed,
            activeColor: _primary,
            side: const BorderSide(color: Color(0xFFD5CABF), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (v) => setState(() => _agreed = v ?? false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'Saya menyetujui ',
              style: const TextStyle(fontSize: 14, color: _dark, height: 1.4),
              children: [
                TextSpan(
                  text: 'Ketentuan Layanan',
                  recognizer: _termsTap,
                  style: const TextStyle(
                    color: _linkColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' dan '),
                TextSpan(
                  text: 'Kebijakan Privasi',
                  recognizer: _privacyTap,
                  style: const TextStyle(
                    color: _linkColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' Pagesy.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
