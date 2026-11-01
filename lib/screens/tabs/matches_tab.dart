import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});
  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  String _format = 'T20';

  final List<Map<String, dynamic>> _cricket = [
    {'tour': 'Indian Premier League', 'format': 'T20', 't1': 'Mumbai Indians', 't2': 'Chennai Super Kings', 's1': '198/5 (20)', 's2': '176/8 (18.4)', 'status': 'CSK need 23 in 8 balls', 'live': true},
    {'tour': 'India Tour of Australia', 'format': 'ODI', 't1': 'India', 't2': 'Australia', 's1': '312/6 (50)', 's2': '289 (48.2)', 'status': 'IND won by 23 runs', 'live': false},
    {'tour': 'Border-Gavaskar Trophy', 'format': 'Test', 't1': 'India', 't2': 'Australia', 's1': '364 & 180/3', 's2': '290 & 240', 'status': 'Day 4 - Stumps', 'live': true},
  ];

  @override
  Widget build(BuildContext context) {
    final list = _cricket.where((e) => e['format'] == _format).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cricket Center', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.filterBg, borderRadius: BorderRadius.circular(8)),
                child: const Text('IPL & India', style: TextStyle(color: AppTheme.accentYellow, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: ['T20', 'ODI', 'Test'].map((fmt) {
              final sel = _format == fmt;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(fmt),
                  selected: sel,
                  onSelected: (_) => setState(() => _format = fmt),
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.filterBg,
                  labelStyle: TextStyle(color: sel ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ...list.map((m) => Card(
            color: AppTheme.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m['tour'], style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      if (m['live'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                          child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m['t1'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      Text(m['s1'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m['t2'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      Text(m['s2'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(m['status'], style: const TextStyle(color: AppTheme.accentYellow, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
