import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../core/constants/app_colors.dart';
import '../core/network/graphql_client.dart';
import '../features/home/presentation/home_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientNotifier = ref.watch(graphQLClientProvider);

    return GraphQLProvider(
      client: clientNotifier,
      child: MaterialApp(
        title: 'Pagesy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          useMaterial3: true,
        ),
        home: const HomeScreen(), // <-- Halaman awal Note perlu perbaikan karena perlu login
      ),
    );
  }
}
