import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Teams', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
          const SizedBox(height: 16),
          Card(
            color: AppTheme.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: CircleAvatar(backgroundColor: AppTheme.primary, child: Text('IND', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              title: Text('Team India (Men in Blue)', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              subtitle: Text('National Cricket Team', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppTheme.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: CircleAvatar(backgroundColor: AppTheme.filterBg, child: Text('MI', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold))),
              title: Text('Mumbai Indians', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              subtitle: Text('IPL Franchise', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
