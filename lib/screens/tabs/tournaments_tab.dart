import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cricket_match_service.dart';

class TournamentsTab extends StatefulWidget {
  const TournamentsTab({super.key});

  @override
  State<TournamentsTab> createState() => _TournamentsTabState();
}

class _TournamentsTabState extends State<TournamentsTab> {
  final CricketMatchService _service = CricketMatchService();
  String _searchQuery = '';

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
    var tours = _service.tournaments;

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      tours = tours.where((t) {
        final matchesTour = t.name.toLowerCase().contains(q);
        final matchesTeam = t.standings.any((s) => s['team'].toString().toLowerCase().contains(q));
        return matchesTour || matchesTeam;
      }).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Tournaments & Series', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search tournament or team...',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.darkNav,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 16),

            if (tours.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.emoji_events_outlined, size: 48, color: AppTheme.textSecondary),
                    SizedBox(height: 12),
                    Text(
                      'No tournaments or teams match your search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              ...tours.map((t) {
                final isFav = _service.favTournaments.contains(t.id);
                return Card(
                  color: AppTheme.surfaceCard,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    onTap: () => _showTournamentDetails(context, t),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.filterBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.emoji_events_rounded, color: AppTheme.accentYellow, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.name,
                                  style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${t.format} Format • ${t.standings.length} Teams',
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: isFav ? AppTheme.accentYellow : AppTheme.textSecondary,
                            ),
                            onPressed: () => _service.toggleFavoriteTournament(t.id),
                          ),
                          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _showTournamentDetails(BuildContext context, CricketTournament t) {
    final fixtures = _service.matches.where((m) => m.tournament == t.name).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          t.name,
                          style: const TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          t.format,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Points table
                  const Text('Points Table', style: TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkNav,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: const BoxDecoration(
                            color: AppTheme.filterBg,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 22, child: Text('#', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Team', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                              SizedBox(width: 26, child: Text('P', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                              SizedBox(width: 26, child: Text('W', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                              SizedBox(width: 26, child: Text('L', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                              SizedBox(width: 44, child: Text('NRR', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                              SizedBox(width: 30, child: Text('Pts', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.accentYellow, fontSize: 11, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        ...t.standings.map((s) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 22,
                                    child: Text('${s['rank']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                  ),
                                  Expanded(
                                    child: Text(s['team'], style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.w600, fontSize: 12)),
                                  ),
                                  SizedBox(width: 26, child: Text('${s['p']}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))),
                                  SizedBox(width: 26, child: Text('${s['w']}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))),
                                  SizedBox(width: 26, child: Text('${s['l']}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))),
                                  SizedBox(width: 44, child: Text('${s['nrr']}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11))),
                                  SizedBox(width: 30, child: Text('${s['pts']}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.accentYellow, fontWeight: FontWeight.bold, fontSize: 12))),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Fixtures & Results', style: TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (fixtures.isEmpty)
                    const Text('No fixtures recorded for this series.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))
                  else
                    ...fixtures.map((m) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.darkNav,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text('${m.date} • ${m.timeIST}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Text(m.scoreA != null ? '${m.scoreA} | ${m.scoreB ?? ""}' : m.status, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        )),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
