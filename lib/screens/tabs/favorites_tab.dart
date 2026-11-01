import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cricket_match_service.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final CricketMatchService _service = CricketMatchService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favMatches = _service.matches.where((m) => _service.favMatchIds.contains(m.id)).toList();
    final favTours = _service.tournaments.where((t) => _service.favTournaments.contains(t.id)).toList();
    final favTeams = _service.favTeams.toList();

    final bool isEmpty = favMatches.isEmpty && favTours.isEmpty && favTeams.isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Favorites', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.star_border_rounded, size: 54, color: AppTheme.textSecondary),
                    SizedBox(height: 16),
                    Text(
                      'No Cricket Favorites',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bookmark matches, series, or teams to track updates in one place.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Followed Teams
                  if (favTeams.isNotEmpty) ...[
                    const Text('Followed Teams', style: TextStyle(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: favTeams.map((team) {
                        return Chip(
                          backgroundColor: AppTheme.filterBg,
                          label: Text(team, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          deleteIcon: const Icon(Icons.close, size: 16, color: AppTheme.textSecondary),
                          onDeleted: () => _service.toggleFavoriteTeam(team),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Saved Matches
                  if (favMatches.isNotEmpty) ...[
                    const Text('Saved Matches', style: TextStyle(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...favMatches.map((m) => Card(
                          color: AppTheme.surfaceCard,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${m.format} • ${m.tournament}',
                                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${m.teamA} vs ${m.teamB}',
                                        style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${m.date} at ${m.timeIST} • ${m.status}',
                                        style: const TextStyle(color: AppTheme.accentYellow, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.star_rounded, color: AppTheme.accentYellow),
                                  onPressed: () => _service.toggleFavoriteMatch(m.id),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],

                  // Saved Tournaments
                  if (favTours.isNotEmpty) ...[
                    const Text('Saved Tournaments', style: TextStyle(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...favTours.map((t) => Card(
                          color: AppTheme.surfaceCard,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(Icons.emoji_events, color: AppTheme.accentYellow),
                            title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                            subtitle: Text('${t.format} Format • ${t.standings.length} Teams', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            trailing: IconButton(
                              icon: const Icon(Icons.star_rounded, color: AppTheme.accentYellow),
                              onPressed: () => _service.toggleFavoriteTournament(t.id),
                            ),
                          ),
                        )),
                  ],
                ],
              ),
      ),
    );
  }
}
