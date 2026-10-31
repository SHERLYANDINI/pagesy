import 'package:flutter/material.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/book/presentation/book_search_screen.dart';
import '../../features/reading_session/presentation/reading_session_screen.dart';

import '../../features/friends/presentation/friends_list_screen.dart';
import '../../features/profile/presentation/user_profile_screen.dart';

enum MainTab { home, search, session, social, profile }

void handleTabTransition(
  BuildContext context,
  MainTab currentTab,
  MainTab targetTab,
) {
  if (currentTab == targetTab) return;

  Widget destinationScreen;

  switch (targetTab) {
    case MainTab.home:
      destinationScreen = const HomeScreen();
      break;
    case MainTab.search:
      destinationScreen = const SearchScreen();
      break;
    case MainTab.session:
      destinationScreen = const SessionScreen();
      break;
    case MainTab.social:
      destinationScreen = const SocialScreen();
      break;
    case MainTab.profile:
      destinationScreen = const ProfileScreen();
      break;
  }

  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          destinationScreen,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}
