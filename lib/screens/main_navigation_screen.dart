import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tabs/matches_tab.dart';
import 'tabs/tournaments_tab.dart';
import 'tabs/favorites_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  final List<Widget> _tabs = const [
    MatchesTab(),
    TournamentsTab(),
    FavoritesTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Container(
        color: AppTheme.darkNav,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: AppTheme.darkNav,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.sports_cricket_rounded), label: 'Matches'),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events_rounded), label: 'Tournaments'),
            BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Favorites'),
          ],
        ),
      ),
    );
  }
}
