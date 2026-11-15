import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/swing_repository.dart';
import '../features/home/home_screen.dart';
import '../features/log/log_screen.dart';
import '../features/log/swing_detail_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/practice/practice_screen.dart';
import '../features/record/camera_screen.dart';
import '../features/record/import_screen.dart';
import '../features/record/record_screen.dart';
import '../features/record/setup_screen.dart';
import '../features/settings/settings_screen.dart';
import 'labels.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(profileProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final profile = ref.read(profileProvider);
      final loc = state.matchedLocation;
      if (!profile.hasValue) return profile.hasError ? null : '/';
      if (profile.value == null) return loc == '/onboarding' ? null : '/onboarding';
      if (loc == '/' || loc == '/onboarding') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Scaffold()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(
        path: '/setup/:mode',
        builder: (_, s) => SetupScreen(guided: s.pathParameters['mode'] == 'guided'),
      ),
      GoRoute(
        path: '/camera',
        builder: (_, s) => CameraScreen(setup: s.extra! as SessionSetup),
      ),
      GoRoute(path: '/import', builder: (_, _) => const ImportScreen()),
      GoRoute(
        path: '/swing/:id',
        builder: (_, s) => SwingDetailScreen(swingId: s.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => _TabShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/record', builder: (_, _) => const RecordScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/log', builder: (_, _) => const LogScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/practice', builder: (_, _) => const PracticeScreen()),
          ]),
        ],
      ),
    ],
  );
});

/// Bottom tabs: Cupertino tab bar on iOS, Material 3 navigation bar on
/// Android (UI_UX_SPEC §12).
class _TabShell extends StatelessWidget {
  const _TabShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (Icons.home_outlined, Icons.home, l.tabHome),
      (Icons.videocam_outlined, Icons.videocam, l.tabRecord),
      (Icons.history, Icons.history, l.tabLog),
      (Icons.sports_golf_outlined, Icons.sports_golf, l.tabPractice),
    ];
    void onTap(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      body: shell,
      bottomNavigationBar: isIOS
          ? CupertinoTabBar(
              currentIndex: shell.currentIndex,
              onTap: onTap,
              activeColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              items: [
                for (final (icon, active, label) in items)
                  BottomNavigationBarItem(
                      icon: Icon(icon), activeIcon: Icon(active), label: label),
              ],
            )
          : NavigationBar(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: onTap,
              destinations: [
                for (final (icon, active, label) in items)
                  NavigationDestination(
                      icon: Icon(icon), selectedIcon: Icon(active), label: label),
              ],
            ),
    );
  }
}
