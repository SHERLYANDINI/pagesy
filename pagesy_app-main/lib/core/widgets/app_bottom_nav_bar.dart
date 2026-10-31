import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../navigation/app_navigation.dart';

class AppBottomNavBar extends StatelessWidget {
  final MainTab currentTab;

  const AppBottomNavBar({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentTab.index,
        onTap: (index) {
          final selectedTab = MainTab.values[index];
          handleTabTransition(context, currentTab, selectedTab);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: currentTab == MainTab.home
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: currentTab == MainTab.home
                    ? Colors.white
                    : AppColors.textMuted,
              ),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Session',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            label: 'Social',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
