import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teman & Komunitas')),
      body: const Center(child: Text('Konten Halaman Teman')),

      bottomNavigationBar: const AppBottomNavBar(currentTab: MainTab.social),
    );
  }
}
