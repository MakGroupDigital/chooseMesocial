/// Configuration pour l'API Football
class ApiConfig {
  // Configuration pour TheSportsDB (API 100% gratuite, sans clé requise)
  // Documentation: https://www.thesportsdb.com/api.php
  static const String theSportsDbBaseUrl = 'https://www.thesportsdb.com/api/v1/json/3';
  
  // Configuration alternative pour Football-Data.org (nécessite une clé)
  static const String footballDataApiKey = '5499c9fc2d0d467b8b62bf70708460f8';
  static const String footballDataBaseUrl = 'https://api.football-data.org/v4';
  
  // Paramètres de cache
  static const Duration cacheExpiration = Duration(minutes: 5);
  static const Duration apiTimeout = Duration(seconds: 10);
  
  // IDs des ligues supportées sur TheSportsDB
  static const Map<String, String> supportedLeagues = {
    'Premier League': '4328',
    'La Liga': '4335',
    'Bundesliga': '4331',
    'Serie A': '4332',
    'Ligue 1': '4334',
    'Champions League': '4480',
    'Europa League': '4481',
  };
  
  /// Retourne l'URL de base à utiliser (TheSportsDB par défaut)
  static String get baseUrl {
    return theSportsDbBaseUrl;
  }
  
  /// Vérifie si la configuration API est valide
  /// TheSportsDB ne nécessite pas de clé, donc toujours configuré
  static bool get isConfigured {
    return true; // TheSportsDB est toujours disponible sans clé
  }
  
  /// Retourne la clé API (non nécessaire pour TheSportsDB)
  static String? get apiKey {
    return null; // Pas de clé nécessaire
  }
}