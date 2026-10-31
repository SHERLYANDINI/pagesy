import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: const Center(child: Text('Konten Halaman Profil')),

      bottomNavigationBar: const AppBottomNavBar(currentTab: MainTab.profile),
    );
  }
}
