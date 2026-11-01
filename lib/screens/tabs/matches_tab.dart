import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cricket_match_service.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  final CricketMatchService _service = CricketMatchService();
  String _statusTab = 'LIVE'; // 'LIVE', 'Upcoming', 'Results'
  String _formatFilter = 'All'; // 'All', 'T20', 'ODI', 'Test'
  String _dateFilter = 'Today';

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
    var matches = _service.matches;

    // Filter by status tab
    if (_statusTab == 'LIVE') {
      matches = matches.where((m) => m.isLive).toList();
    } else if (_statusTab == 'Upcoming') {
      matches = matches.where((m) => !m.isLive && m.scoreA == null).toList();
    } else if (_statusTab == 'Results') {
      matches = matches.where((m) => !m.isLive && m.scoreA != null).toList();
    }

    // Filter by format
    if (_formatFilter != 'All') {
      matches = matches.where((m) => m.format == _formatFilter).toList();
    }

    // Filter by date if not LIVE
    if (_statusTab != 'LIVE') {
      matches = matches.where((m) => m.date == _dateFilter).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cricket Match Center',
              style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Updated ${_service.lastUpdated.hour.toString().padLeft(2, '0')}:${_service.lastUpdated.minute.toString().padLeft(2, '0')} IST',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Demo',
                style: TextStyle(color: Color(0xFF0B1928), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _service.refresh,
        color: AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LIVE / Upcoming / Results Status Ribbon
              Row(
                children: ['LIVE', 'Upcoming', 'Results'].map((st) {
                  final isSel = _statusTab == st;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => setState(() => _statusTab = st),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSel ? AppTheme.primary : AppTheme.darkNav,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(0, 42),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                        ),
                        child: Text(
                          st,
                          style: TextStyle(
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Format chips (T20, ODI, Test)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'T20', 'ODI', 'Test'].map((fmt) {
                    final isSel = _formatFilter == fmt;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(fmt),
                        selected: isSel,
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.darkNav,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (_) => setState(() => _formatFilter = fmt),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Date ribbon (if not LIVE)
              if (_statusTab != 'LIVE') ...[
                Row(
                  children: ['Yesterday', 'Today', 'Tomorrow'].map((d) {
                    final isSel = _dateFilter == d;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlinedButton(
                          onPressed: () => setState(() => _dateFilter = d),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSel ? AppTheme.filterBg : AppTheme.darkNav,
                            side: BorderSide(color: isSel ? AppTheme.accentYellow : Colors.transparent),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                            minimumSize: const Size(0, 38),
                          ),
                          child: Text(
                            d,
                            style: TextStyle(
                              color: isSel ? AppTheme.accentYellow : AppTheme.textSecondary,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ] else
                const SizedBox(height: 4),

              // Matches list
              if (matches.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.sports_cricket_rounded, size: 48, color: AppTheme.textSecondary),
                      SizedBox(height: 12),
                      Text(
                        'No matches available for this view.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                )
              else
                ...matches.map((match) => _buildCricketCard(context, match)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCricketCard(BuildContext context, CricketMatch match) {
    final isFav = _service.favMatchIds.contains(match.id);
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () => _showMatchDetails(context, match),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tournament, Format & Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.filterBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          match.format,
                          style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        match.tournament,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (match.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _service.toggleFavoriteMatch(match.id),
                        child: Icon(
                          isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: isFav ? AppTheme.accentYellow : AppTheme.textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 20),

              // Team A
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    match.teamA,
                    style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (match.scoreA != null)
                    Text(
                      '${match.scoreA} ${match.oversA != null ? "(${match.oversA})" : ""}',
                      style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Team B
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    match.teamB,
                    style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (match.scoreB != null)
                    Text(
                      '${match.scoreB} ${match.oversB != null ? "(${match.oversB})" : ""}',
                      style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Status Summary & Venue
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.filterBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.status,
                      style: const TextStyle(color: AppTheme.accentYellow, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${match.timeIST} • ${match.venue}',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context, CricketMatch match) {
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
                          '${match.format} • ${match.tournament}',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (match.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${match.teamA} vs ${match.teamB}',
                    style: const TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${match.date} • ${match.timeIST} • ${match.venue}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                  const Divider(color: AppTheme.border, height: 24),

                  // Score summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkNav,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(match.teamA, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(match.scoreA ?? 'Yet to bat', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(match.teamB, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(match.scoreB ?? 'Yet to bat', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            match.summary,
                            style: const TextStyle(color: AppTheme.accentYellow, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recent balls
                  if (match.recentBalls.isNotEmpty) ...[
                    const Text('Recent Deliveries', style: TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: match.recentBalls.map((ball) {
                        final isWicket = ball == 'W';
                        final isSix = ball == '6';
                        final isFour = ball == '4';
                        return Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isWicket
                                ? Colors.red.shade700
                                : isSix
                                    ? AppTheme.accentYellow
                                    : isFour
                                        ? AppTheme.primary
                                        : AppTheme.filterBg,
                          ),
                          child: Center(
                            child: Text(
                              ball,
                              style: TextStyle(
                                color: isSix ? const Color(0xFF0B1928) : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Batters table
                  if (match.batters.isNotEmpty) ...[
                    const Text('Batting Scorecard', style: TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.darkNav,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: const BoxDecoration(
                              color: AppTheme.filterBg,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                            child: const Row(
                              children: [
                                Expanded(child: Text('Batter', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 30, child: Text('R', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 30, child: Text('B', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 30, child: Text('4s', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 30, child: Text('6s', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 45, child: Text('SR', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          ...match.batters.map((b) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(b.name, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.w600, fontSize: 13))),
                                    SizedBox(width: 30, child: Text('${b.runs}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 30, child: Text('${b.balls}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                                    SizedBox(width: 30, child: Text('${b.fours}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                                    SizedBox(width: 30, child: Text('${b.sixes}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                                    SizedBox(width: 45, child: Text(b.sr.toStringAsFixed(1), textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.accentYellow, fontSize: 12))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Bowlers table
                  if (match.bowlers.isNotEmpty) ...[
                    const Text('Bowling Scorecard', style: TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.darkNav,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: const BoxDecoration(
                              color: AppTheme.filterBg,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                            child: const Row(
                              children: [
                                Expanded(child: Text('Bowler', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 35, child: Text('O', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 30, child: Text('M', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 30, child: Text('R', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 30, child: Text('W', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                                SizedBox(width: 45, child: Text('Econ', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          ...match.bowlers.map((bw) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(bw.name, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.w600, fontSize: 13))),
                                    SizedBox(width: 35, child: Text(bw.overs, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                                    SizedBox(width: 30, child: Text('${bw.maidens}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                                    SizedBox(width: 30, child: Text('${bw.runs}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                                    SizedBox(width: 30, child: Text('${bw.wickets}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 45, child: Text(bw.econ.toStringAsFixed(2), textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.accentYellow, fontSize: 12))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
