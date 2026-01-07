import '/core/flutter_flow/flutter_flow_util.dart';
import '/features/live_match/services/football_api_service.dart';
import 'matches_list_widget.dart' show MatchesListWidget;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchesListModel extends FlutterFlowModel<MatchesListWidget> {
  /// State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();
  
  // Service API Football
  final FootballApiService _apiService = FootballApiService.instance;
  
  // État des données
  List<MatchData> matches = [];
  bool isLoading = true;
  String? errorMessage;
  bool isFromCache = false;
  
  // Timer pour le rafraîchissement automatique
  Timer? _refreshTimer;
  
  // Contrôleur pour le refresh indicator
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState(BuildContext context) {
    _loadMatches();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    _refreshTimer?.cancel();
  }

  /// Charge les matchs depuis l'API
  Future<void> _loadMatches() async {
    try {
      final result = await _apiService.getTodayMatches();
      
      if (result.isSuccess && result.data != null) {
        matches = result.data!;
        isFromCache = result.isFromCache;
        errorMessage = null;
      } else if (result.isError) {
        errorMessage = result.error;
        // En cas d'erreur, essayer les données de test
        if (matches.isEmpty) {
          matches = _apiService.getTestMatches();
          isFromCache = true;
        }
      }
    } catch (e) {
      errorMessage = 'Erreur de chargement: $e';
      // Utiliser les données de test en cas d'erreur
      matches = _apiService.getTestMatches();
      isFromCache = true;
    } finally {
      isLoading = false;
    }
  }

  /// Rafraîchit les données
  Future<void> refreshMatches() async {
    isLoading = true;
    await _loadMatches();
  }

  /// Démarre le rafraîchissement automatique toutes les 60 secondes
  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (!isLoading) {
        _updateLiveScores();
      }
    });
  }

  /// Met à jour uniquement les scores des matchs en direct
  Future<void> _updateLiveScores() async {
    final liveMatchIds = matches
        .where((match) => match.status == 'live')
        .map((match) => match.id)
        .toList();
    
    if (liveMatchIds.isEmpty) return;
    
    try {
      final result = await _apiService.getLiveScores(liveMatchIds);
      if (result.isSuccess && result.data != null) {
        final scores = result.data!;
        
        // Mettre à jour les scores dans la liste
        for (final score in scores) {
          final matchIndex = matches.indexWhere((m) => m.id == score.matchId);
          if (matchIndex != -1) {
            final match = matches[matchIndex];
            matches[matchIndex] = MatchData(
              id: match.id,
              homeTeamName: match.homeTeamName,
              homeTeamLogo: match.homeTeamLogo,
              awayTeamName: match.awayTeamName,
              awayTeamLogo: match.awayTeamLogo,
              competition: match.competition,
              startTime: match.startTime,
              status: score.status,
              homeScore: score.homeScore,
              awayScore: score.awayScore,
              minute: score.minute,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur mise à jour scores: $e');
    }
  }

  /// Retourne le statut formaté pour l'affichage
  String getFormattedStatus(MatchData match) {
    switch (match.status) {
      case 'live':
        return match.minute != null ? "${match.minute}'" : 'LIVE';
      case 'finished':
        return 'TERMINÉ';
      case 'scheduled':
        return DateFormat('HH:mm').format(match.startTime);
      case 'postponed':
        return 'REPORTÉ';
      default:
        return match.status.toUpperCase();
    }
  }

  /// Retourne la couleur du statut
  Color getStatusColor(MatchData match) {
    switch (match.status) {
      case 'live':
        return const Color(0xFFFF4757); // Rouge pour LIVE
      case 'finished':
        return const Color(0xFF57606F); // Gris pour terminé
      case 'scheduled':
        return const Color(0xFF19DB8A); // Vert ChooseMe pour programmé
      case 'postponed':
        return const Color(0xFFFFA502); // Orange pour reporté
      default:
        return const Color(0xFF57606F);
    }
  }

  /// Vérifie si un match peut recevoir des pronostics
  bool canMakePrediction(MatchData match) {
    return match.status == 'scheduled' && 
           match.startTime.isAfter(DateTime.now());
  }

  /// Retourne le temps restant avant le début du match
  String getTimeUntilStart(MatchData match) {
    if (match.status != 'scheduled') return '';
    
    final now = DateTime.now();
    final difference = match.startTime.difference(now);
    
    if (difference.isNegative) return '';
    
    if (difference.inDays > 0) {
      return 'Dans ${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return 'Dans ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'Dans ${difference.inMinutes}min';
    } else {
      return 'Bientôt';
    }
  }
}