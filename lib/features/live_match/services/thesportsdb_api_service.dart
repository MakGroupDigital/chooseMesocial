import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/core/flutter_flow/flutter_flow_util.dart';
import 'api_config.dart';

/// Service pour l'intégration avec TheSportsDB (API 100% gratuite, sans clé)
/// Documentation: https://www.thesportsdb.com/api.php
class TheSportsDbApiService {
  static TheSportsDbApiService? _instance;
  static TheSportsDbApiService get instance => _instance ??= TheSportsDbApiService._();
  
  TheSportsDbApiService._();
  
  // Cache pour les données
  static final Map<String, dynamic> _cache = {};
  static DateTime? _lastCacheUpdate;
  
  /// Récupère les matchs du jour pour toutes les ligues supportées
  Future<ApiResult<List<MatchData>>> getTodayMatches() async {
    try {
      final today = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(today);
      
      debugPrint('🔍 Récupération des matchs pour le $dateStr');
      
      final allMatches = <MatchData>[];
      
      // Récupérer les matchs pour chaque ligue
      for (final entry in ApiConfig.supportedLeagues.entries) {
        try {
          final leagueName = entry.key;
          final leagueId = entry.value;
          
          final uri = Uri.parse(
            '${ApiConfig.baseUrl}/eventsday.php?d=$dateStr&l=$leagueId'
          );
          
          debugPrint('📡 Requête: $uri');
          
          final response = await http.get(uri).timeout(ApiConfig.apiTimeout);
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final events = data['events'] as List?;
            
            if (events != null && events.isNotEmpty) {
              debugPrint('✅ ${events.length} matchs trouvés pour $leagueName');
              
              for (final event in events) {
                try {
                  final match = MatchData.fromTheSportsDb(event, leagueName);
                  allMatches.add(match);
                } catch (e) {
                  debugPrint('⚠️ Erreur parsing match: $e');
                }
              }
            } else {
              debugPrint('ℹ️ Aucun match pour $leagueName');
            }
          }
          
          // Petite pause pour éviter de surcharger l'API
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          debugPrint('❌ Erreur pour ${entry.key}: $e');
        }
      }
      
      // Si aucun match trouvé, utiliser les données de test
      if (allMatches.isEmpty) {
        debugPrint('⚠️ Aucun match trouvé, utilisation des données de test');
        return ApiResult.success(getTestMatches(), isFromCache: true);
      }
      
      // Trier par heure de début
      allMatches.sort((a, b) => a.startTime.compareTo(b.startTime));
      
      // Mettre en cache
      _cache['today_matches'] = allMatches;
      _cache['today_matches_timestamp'] = DateTime.now().millisecondsSinceEpoch;
      _lastCacheUpdate = DateTime.now();
      
      debugPrint('✅ Total: ${allMatches.length} matchs récupérés');
      
      return ApiResult.success(allMatches);
    } catch (e) {
      debugPrint('❌ Erreur API: $e');
      
      // Essayer le cache
      final cachedMatches = _getCachedTodayMatches();
      if (cachedMatches.isNotEmpty) {
        return ApiResult.cached(cachedMatches);
      }
      
      // Fallback sur les données de test
      return ApiResult.success(getTestMatches(), isFromCache: true);
    }
  }
  
  /// Récupère les scores en direct pour les matchs actifs
  Future<ApiResult<List<MatchScore>>> getLiveScores(List<String> matchIds) async {
    try {
      final scores = <MatchScore>[];
      
      for (final matchId in matchIds) {
        // Ignorer les IDs de test
        if (matchId.startsWith('test_')) {
          scores.add(_getTestScore(matchId));
          continue;
        }
        
        try {
          final uri = Uri.parse(
            '${ApiConfig.baseUrl}/lookupevent.php?id=$matchId'
          );
          
          final response = await http.get(uri).timeout(ApiConfig.apiTimeout);
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final events = data['events'] as List?;
            
            if (events != null && events.isNotEmpty) {
              final event = events[0];
              scores.add(MatchScore.fromTheSportsDb(event));
            }
          }
          
          // Petite pause entre les requêtes
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          debugPrint('Erreur récupération score pour $matchId: $e');
        }
      }
      
      return ApiResult.success(scores);
    } catch (e) {
      debugPrint('Erreur Live Scores: $e');
      return ApiResult.error('Erreur lors de la récupération des scores: $e');
    }
  }
  
  /// Récupère les détails d'un match spécifique
  Future<ApiResult<MatchData>> getMatchDetails(String matchId) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/lookupevent.php?id=$matchId'
      );
      
      final response = await http.get(uri).timeout(ApiConfig.apiTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final events = data['events'] as List?;
        
        if (events != null && events.isNotEmpty) {
          final event = events[0];
          final match = MatchData.fromTheSportsDb(event, event['strLeague'] ?? '');
          return ApiResult.success(match);
        }
      }
      
      return ApiResult.error('Match non trouvé');
    } catch (e) {
      debugPrint('Erreur détails match: $e');
      return ApiResult.error('Erreur de connexion: $e');
    }
  }
  
  /// Récupère les matchs depuis le cache
  List<MatchData> _getCachedTodayMatches() {
    if (_cache.containsKey('today_matches')) {
      final timestamp = _cache['today_matches_timestamp'] as int?;
      if (timestamp != null) {
        final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
        if (cacheAge > ApiConfig.cacheExpiration.inMilliseconds) {
          return [];
        }
      }
      return _cache['today_matches'] as List<MatchData>;
    }
    return [];
  }
  
  /// Génère un score de test
  MatchScore _getTestScore(String matchId) {
    return MatchScore(
      matchId: matchId,
      homeScore: matchId == 'test_2' ? 1 : 0,
      awayScore: matchId == 'test_2' ? 2 : 0,
      status: matchId == 'test_2' ? 'live' : 'scheduled',
      minute: matchId == 'test_2' ? 75 : null,
    );
  }
  
  /// Vérifie si l'API est disponible
  Future<bool> isApiAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/all_leagues.php'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// Retourne l'âge du cache en minutes
  int? getCacheAgeMinutes() {
    if (_lastCacheUpdate == null) return null;
    return DateTime.now().difference(_lastCacheUpdate!).inMinutes;
  }
  
  /// Nettoie le cache expiré
  void clearExpiredCache() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keysToRemove = <String>[];
    
    _cache.forEach((key, value) {
      if (key.endsWith('_timestamp')) {
        final timestamp = value as int;
        if (now - timestamp > ApiConfig.cacheExpiration.inMilliseconds) {
          keysToRemove.add(key);
          keysToRemove.add(key.replaceAll('_timestamp', ''));
        }
      }
    });
    
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }
  
  /// Retourne des données de test pour le développement
  List<MatchData> getTestMatches() {
    final now = DateTime.now();
    
    return [
      MatchData(
        id: 'test_1',
        homeTeamName: 'Real Madrid',
        homeTeamLogo: 'https://www.thesportsdb.com/images/media/team/badge/vwpvry1467462651.png',
        awayTeamName: 'Barcelona',
        awayTeamLogo: 'https://www.thesportsdb.com/images/media/team/badge/txrwth1468770530.png',
        competition: 'La Liga',
        startTime: now.add(const Duration(hours: 2)),
        status: 'scheduled',
        homeScore: 0,
        awayScore: 0,
      ),
      MatchData(
        id: 'test_2',
        homeTeamName: 'Manchester United',
        homeTeamLogo: 'https://www.thesportsdb.com/images/media/team/badge/vwpvry1467462651.png',
        awayTeamName: 'Liverpool',
        awayTeamLogo: 'https://www.thesportsdb.com/images/media/team/badge/uvxuxy1448813372.png',
        competition: 'Premier League',
        startTime: now.subtract(const Duration(minutes: 30)),
        status: 'live',
        homeScore: 1,
        awayScore: 2,
        minute: 75,
      ),
      MatchData(
        id: 'test_3',
        homeTeamName: 'Bayern Munich',
        homeTeamLogo: 'https://www.thesportsdb.com/images/media/team/badge/uxsxqv1448813372.png',
        awayTeamName: 'Borussia Dortmund',
        awayTeamLogo: 'https://www.thesportsdb.com/images/media/team/badge/xqwpup1420746025.png',
        competition: 'Bundesliga',
        startTime: now.add(const Duration(hours: 4)),
        status: 'scheduled',
        homeScore: 0,
        awayScore: 0,
      ),
    ];
  }
}

/// Modèle de données pour un match
class MatchData {
  final String id;
  final String homeTeamName;
  final String homeTeamLogo;
  final String awayTeamName;
  final String awayTeamLogo;
  final String competition;
  final DateTime startTime;
  final String status;
  final int homeScore;
  final int awayScore;
  final int? minute;

  MatchData({
    required this.id,
    required this.homeTeamName,
    required this.homeTeamLogo,
    required this.awayTeamName,
    required this.awayTeamLogo,
    required this.competition,
    required this.startTime,
    required this.status,
    required this.homeScore,
    required this.awayScore,
    this.minute,
  });

  /// Parse depuis TheSportsDB API
  factory MatchData.fromTheSportsDb(Map<String, dynamic> json, String leagueName) {
    // Parser la date et l'heure
    final dateStr = json['dateEvent'] as String?;
    final timeStr = json['strTime'] as String?;
    
    DateTime startTime = DateTime.now();
    if (dateStr != null) {
      try {
        startTime = DateTime.parse(dateStr);
        if (timeStr != null && timeStr.isNotEmpty) {
          // Format: "20:00:00"
          final timeParts = timeStr.split(':');
          if (timeParts.length >= 2) {
            startTime = DateTime(
              startTime.year,
              startTime.month,
              startTime.day,
              int.parse(timeParts[0]),
              int.parse(timeParts[1]),
            );
          }
        }
      } catch (e) {
        debugPrint('Erreur parsing date: $e');
      }
    }
    
    // Déterminer le statut
    String status = 'scheduled';
    final statusStr = json['strStatus'] as String?;
    if (statusStr != null) {
      if (statusStr.contains('FT') || statusStr.contains('Finished')) {
        status = 'finished';
      } else if (statusStr.contains('Live') || statusStr.contains('1H') || 
                 statusStr.contains('2H') || statusStr.contains('HT')) {
        status = 'live';
      } else if (statusStr.contains('Postponed') || statusStr.contains('Cancelled')) {
        status = 'postponed';
      }
    }
    
    return MatchData(
      id: json['idEvent']?.toString() ?? '',
      homeTeamName: json['strHomeTeam'] ?? '',
      homeTeamLogo: json['strHomeTeamBadge'] ?? json['strThumb'] ?? '',
      awayTeamName: json['strAwayTeam'] ?? '',
      awayTeamLogo: json['strAwayTeamBadge'] ?? '',
      competition: leagueName,
      startTime: startTime,
      status: status,
      homeScore: int.tryParse(json['intHomeScore']?.toString() ?? '0') ?? 0,
      awayScore: int.tryParse(json['intAwayScore']?.toString() ?? '0') ?? 0,
      minute: null, // TheSportsDB ne fournit pas la minute en temps réel
    );
  }

  /// Détermine le résultat du match pour les pronostics
  String getResult() {
    if (status != 'finished') return 'pending';
    
    if (homeScore > awayScore) return 'team_a';
    if (awayScore > homeScore) return 'team_b';
    return 'draw';
  }
}

/// Modèle pour les scores en direct
class MatchScore {
  final String matchId;
  final int homeScore;
  final int awayScore;
  final String status;
  final int? minute;

  MatchScore({
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    this.minute,
  });

  factory MatchScore.fromTheSportsDb(Map<String, dynamic> json) {
    String status = 'scheduled';
    final statusStr = json['strStatus'] as String?;
    if (statusStr != null) {
      if (statusStr.contains('FT') || statusStr.contains('Finished')) {
        status = 'finished';
      } else if (statusStr.contains('Live') || statusStr.contains('1H') || 
                 statusStr.contains('2H') || statusStr.contains('HT')) {
        status = 'live';
      }
    }
    
    return MatchScore(
      matchId: json['idEvent']?.toString() ?? '',
      homeScore: int.tryParse(json['intHomeScore']?.toString() ?? '0') ?? 0,
      awayScore: int.tryParse(json['intAwayScore']?.toString() ?? '0') ?? 0,
      status: status,
      minute: null,
    );
  }
}

/// Résultat d'une opération avec gestion d'erreur
class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isFromCache;

  ApiResult.success(this.data, {this.isFromCache = false}) : error = null;
  ApiResult.error(this.error, {this.isFromCache = false}) : data = null;
  ApiResult.cached(this.data) : error = null, isFromCache = true;

  bool get isSuccess => data != null && error == null;
  bool get isError => error != null;
}
