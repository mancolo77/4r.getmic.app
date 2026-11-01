import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TournamentsTab extends StatelessWidget {
  const TournamentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cricket Series', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
          const SizedBox(height: 16),
          Card(
            color: AppTheme.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: Icon(Icons.emoji_events, color: AppTheme.accentYellow, size: 28),
              title: Text('Indian Premier League (IPL)', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              subtitle: Text('10 Franchises • T20 Tournament', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppTheme.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: Icon(Icons.public, color: AppTheme.primary, size: 28),
              title: Text('ICC T20 World Cup', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              subtitle: Text('International Cricket Council', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
