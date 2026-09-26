// core/router/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Persistent Scaffold + bottom nav bar wrapping every tab route.
/// StatefulShellRoute.indexedStack passes this the navigationShell,
/// which tracks which branch is active and preserves each branch's own
/// navigation stack (and scroll position) when switching tabs — a
/// plain ShellRoute would rebuild the destination fresh every switch.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        // unselectedItemColor: AppColors.slate500,
        // selectedItemColor: AppColors.primary700,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Tapping the ALREADY-active tab resets it to its root route
          // instead of just re-showing wherever you'd drilled into —
          // standard bottom-nav behavior (e.g. tapping "Home" again
          // pops back to the top of Home).
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Courses'),
          BottomNavigationBarItem(icon:  Icon(Icons.history), label: 'Profile'),
          // Add a third BottomNavigationBarItem here (e.g. Profile) —
          // it needs a matching StatefulShellBranch in go_router.dart too.
        ],
      ),
    );
  }
}