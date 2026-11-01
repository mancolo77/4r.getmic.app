import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CricketBatter {
  final String name;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double sr;

  const CricketBatter({
    required this.name,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.sr,
  });
}

class CricketBowler {
  final String name;
  final String overs;
  final int maidens;
  final int runs;
  final int wickets;
  final double econ;

  const CricketBowler({
    required this.name,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.econ,
  });
}

class CricketMatch {
  final String id;
  final String tournament;
  final String format; // 'T20', 'ODI', 'Test'
  final String teamA;
  final String teamB;
  final String? scoreA;
  final String? scoreB;
  final String? oversA;
  final String? oversB;
  final bool isLive;
  final String status;
  final String timeIST;
  final String date; // 'Today', 'Tomorrow', 'Yesterday'
  final String venue;
  final String summary;
  final List<CricketBatter> batters;
  final List<CricketBowler> bowlers;
  final List<String> recentBalls;

  const CricketMatch({
    required this.id,
    required this.tournament,
    required this.format,
    required this.teamA,
    required this.teamB,
    this.scoreA,
    this.scoreB,
    this.oversA,
    this.oversB,
    this.isLive = false,
    required this.status,
    required this.timeIST,
    required this.date,
    required this.venue,
    required this.summary,
    this.batters = const [],
    this.bowlers = const [],
    this.recentBalls = const [],
  });
}

class CricketTournament {
  final String id;
  final String name;
  final String format;
  final List<Map<String, dynamic>> standings;

  const CricketTournament({
    required this.id,
    required this.name,
    required this.format,
    required this.standings,
  });
}

class CricketMatchService with ChangeNotifier {
  static final CricketMatchService _instance = CricketMatchService._internal();
  factory CricketMatchService() => _instance;
  CricketMatchService._internal();

  final Set<String> _favMatchIds = {'cm_1'};
  final Set<String> _favTournaments = {'tour_ipl'};
  final Set<String> _favTeams = {'India', 'Mumbai Indians'};
  DateTime _lastUpdated = DateTime.now();

  Set<String> get favMatchIds => Set.unmodifiable(_favMatchIds);
  Set<String> get favTournaments => Set.unmodifiable(_favTournaments);
  Set<String> get favTeams => Set.unmodifiable(_favTeams);
  DateTime get lastUpdated => _lastUpdated;

  final List<CricketTournament> tournaments = const [
    CricketTournament(
      id: 'tour_ipl',
      name: 'Indian Premier League',
      format: 'T20',
      standings: [
        {'rank': 1, 'team': 'Kolkata Knight Riders', 'p': 14, 'w': 9, 'l': 3, 'nrr': '+0.759', 'pts': 20},
        {'rank': 2, 'team': 'Sunrisers Hyderabad', 'p': 14, 'w': 8, 'l': 5, 'nrr': '+0.414', 'pts': 17},
        {'rank': 3, 'team': 'Rajasthan Royals', 'p': 14, 'w': 8, 'l': 5, 'nrr': '+0.273', 'pts': 17},
        {'rank': 4, 'team': 'Royal Challengers Bengaluru', 'p': 14, 'w': 7, 'l': 7, 'nrr': '+0.459', 'pts': 14},
        {'rank': 5, 'team': 'Chennai Super Kings', 'p': 14, 'w': 7, 'l': 7, 'nrr': '+0.392', 'pts': 14},
        {'rank': 6, 'team': 'Delhi Capitals', 'p': 14, 'w': 7, 'l': 7, 'nrr': '-0.377', 'pts': 14},
      ],
    ),
    CricketTournament(
      id: 'tour_t20_wc',
      name: 'ICC Men\'s T20 World Cup',
      format: 'T20',
      standings: [
        {'rank': 1, 'team': 'India', 'p': 8, 'w': 8, 'l': 0, 'nrr': '+1.200', 'pts': 16},
        {'rank': 2, 'team': 'South Africa', 'p': 8, 'w': 7, 'l': 1, 'nrr': '+0.850', 'pts': 14},
        {'rank': 3, 'team': 'England', 'p': 7, 'w': 4, 'l': 3, 'nrr': '+0.540', 'pts': 8},
      ],
    ),
    CricketTournament(
      id: 'tour_bgt',
      name: 'Border-Gavaskar Trophy',
      format: 'Test',
      standings: [
        {'rank': 1, 'team': 'India', 'p': 4, 'w': 2, 'l': 1, 'nrr': '-', 'pts': 28},
        {'rank': 2, 'team': 'Australia', 'p': 4, 'w': 1, 'l': 2, 'nrr': '-', 'pts': 16},
      ],
    ),
  ];

  final List<CricketMatch> matches = const [
    CricketMatch(
      id: 'cm_1',
      tournament: 'Indian Premier League',
      format: 'T20',
      teamA: 'Mumbai Indians',
      teamB: 'Chennai Super Kings',
      scoreA: '178/5',
      scoreB: '142/3',
      oversA: '20.0 ov',
      oversB: '15.4 ov',
      isLive: true,
      status: 'Live • CSKs need 37 off 26',
      timeIST: '19:30 IST',
      date: 'Today',
      venue: 'Wankhede Stadium, Mumbai',
      summary: 'CSK require 37 runs in 26 balls with 7 wickets in hand',
      batters: [
        CricketBatter(name: 'R. Gaikwad', runs: 58, balls: 39, fours: 5, sixes: 2, sr: 148.7),
        CricketBatter(name: 'S. Dube', runs: 34, balls: 19, fours: 1, sixes: 3, sr: 178.9),
      ],
      bowlers: [
        CricketBowler(name: 'J. Bumrah', overs: '3.0', maidens: 0, runs: 18, wickets: 2, econ: 6.0),
        CricketBowler(name: 'G. Coetzee', overs: '3.4', maidens: 0, runs: 36, wickets: 1, econ: 9.8),
      ],
      recentBalls: ['1', '4', '6', '1', '2', '0'],
    ),
    CricketMatch(
      id: 'cm_2',
      tournament: 'ICC Men\'s T20 World Cup',
      format: 'T20',
      teamA: 'India',
      teamB: 'South Africa',
      scoreA: '176/7',
      scoreB: '169/8',
      oversA: '20.0 ov',
      oversB: '20.0 ov',
      isLive: false,
      status: 'Finished',
      timeIST: '20:00 IST',
      date: 'Yesterday',
      venue: 'Kensington Oval, Bridgetown',
      summary: 'India won by 7 runs to lift the Trophy',
      batters: [
        CricketBatter(name: 'V. Kohli', runs: 76, balls: 59, fours: 6, sixes: 2, sr: 128.8),
        CricketBatter(name: 'A. Patel', runs: 47, balls: 31, fours: 1, sixes: 4, sr: 151.6),
      ],
      bowlers: [
        CricketBowler(name: 'J. Bumrah', overs: '4.0', maidens: 0, runs: 18, wickets: 2, econ: 4.5),
        CricketBowler(name: 'H. Pandya', overs: '3.0', maidens: 0, runs: 20, wickets: 3, econ: 6.67),
        CricketBowler(name: 'A. Singh', overs: '4.0', maidens: 0, runs: 20, wickets: 2, econ: 5.0),
      ],
      recentBalls: ['W', '1', '1', '1', 'W', '1'],
    ),
    CricketMatch(
      id: 'cm_3',
      tournament: 'Indian Premier League',
      format: 'T20',
      teamA: 'Royal Challengers Bengaluru',
      teamB: 'Kolkata Knight Riders',
      scoreA: null,
      scoreB: null,
      oversA: null,
      oversB: null,
      isLive: false,
      status: 'Upcoming',
      timeIST: '19:30 IST',
      date: 'Tomorrow',
      venue: 'M. Chinnaswamy Stadium, Bengaluru',
      summary: 'Match starts tomorrow at 19:30 IST',
      batters: [],
      bowlers: [],
      recentBalls: [],
    ),
    CricketMatch(
      id: 'cm_4',
      tournament: 'Border-Gavaskar Trophy',
      format: 'Test',
      teamA: 'Australia',
      teamB: 'India',
      scoreA: '263 & 113',
      scoreB: '262 & 118/4',
      oversA: '78.4 & 31.1 ov',
      oversB: '83.3 & 26.4 ov',
      isLive: false,
      status: 'Finished',
      timeIST: '09:30 IST',
      date: 'Yesterday',
      venue: 'Arun Jaitley Stadium, Delhi',
      summary: 'India won by 6 wickets on Day 3',
      batters: [
        CricketBatter(name: 'R. Sharma', runs: 31, balls: 20, fours: 3, sixes: 2, sr: 155.0),
        CricketBatter(name: 'C. Pujara', runs: 31, balls: 74, fours: 4, sixes: 0, sr: 41.8),
      ],
      bowlers: [
        CricketBowler(name: 'R. Jadeja', overs: '12.1', maidens: 1, runs: 42, wickets: 7, econ: 3.45),
        CricketBowler(name: 'R. Ashwin', overs: '16.0', maidens: 3, runs: 59, wickets: 3, econ: 3.68),
      ],
      recentBalls: ['1', '0', '4', '0', '1', '4'],
    ),
    CricketMatch(
      id: 'cm_5',
      tournament: 'ICC Men\'s T20 World Cup',
      format: 'T20',
      teamA: 'India',
      teamB: 'England',
      scoreA: '171/7',
      scoreB: '103/10',
      oversA: '20.0 ov',
      oversB: '16.4 ov',
      isLive: false,
      status: 'Finished',
      timeIST: '20:00 IST',
      date: 'Yesterday',
      venue: 'Providence Stadium, Guyana',
      summary: 'India won by 68 runs to advance to Final',
      batters: [
        CricketBatter(name: 'R. Sharma', runs: 57, balls: 39, fours: 6, sixes: 2, sr: 146.1),
        CricketBatter(name: 'S. Yadav', runs: 47, balls: 36, fours: 4, sixes: 2, sr: 130.5),
      ],
      bowlers: [
        CricketBowler(name: 'A. Patel', overs: '4.0', maidens: 0, runs: 23, wickets: 3, econ: 5.75),
        CricketBowler(name: 'K. Yadav', overs: '4.0', maidens: 0, runs: 19, wickets: 3, econ: 4.75),
      ],
      recentBalls: ['W', '0', '0', '1', 'W'],
    ),
    CricketMatch(
      id: 'cm_6',
      tournament: 'Indian Premier League',
      format: 'T20',
      teamA: 'Gujarat Titans',
      teamB: 'Delhi Capitals',
      scoreA: null,
      scoreB: null,
      oversA: null,
      oversB: null,
      isLive: false,
      status: 'Upcoming',
      timeIST: '15:30 IST',
      date: 'Tomorrow',
      venue: 'Narendra Modi Stadium, Ahmedabad',
      summary: 'Afternoon clash starts at 15:30 IST',
      batters: [],
      bowlers: [],
      recentBalls: [],
    ),
  ];

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favM = prefs.getStringList('fav_matches_cricket');
      if (favM != null) {
        _favMatchIds.clear();
        _favMatchIds.addAll(favM);
      }
      final favT = prefs.getStringList('fav_tournaments_cricket');
      if (favT != null) {
        _favTournaments.clear();
        _favTournaments.addAll(favT);
      }
      final favTm = prefs.getStringList('fav_teams_cricket');
      if (favTm != null) {
        _favTeams.clear();
        _favTeams.addAll(favTm);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_matches_cricket', _favMatchIds.toList());
      await prefs.setStringList('fav_tournaments_cricket', _favTournaments.toList());
      await prefs.setStringList('fav_teams_cricket', _favTeams.toList());
    } catch (_) {}
  }

  void toggleFavoriteMatch(String id) {
    if (_favMatchIds.contains(id)) {
      _favMatchIds.remove(id);
    } else {
      _favMatchIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleFavoriteTournament(String id) {
    if (_favTournaments.contains(id)) {
      _favTournaments.remove(id);
    } else {
      _favTournaments.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleFavoriteTeam(String team) {
    if (_favTeams.contains(team)) {
      _favTeams.remove(team);
    } else {
      _favTeams.add(team);
    }
    _save();
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _lastUpdated = DateTime.now();
    notifyListeners();
  }
}
