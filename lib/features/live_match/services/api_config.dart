/// Configuration pour l'API Football
class ApiConfig {
  // Configuration pour Football-Data.org (API gratuite)
  // Pour obtenir une clé API gratuite : https://www.football-data.org/client/register
  static const String footballDataApiKey = '5499c9fc2d0d467b8b62bf70708460f8'; // Utilise 'demo' pour les tests
  static const String footballDataBaseUrl = 'https://api.football-data.org/v4';
  
  // Configuration alternative pour API-Sports (si nécessaire)
  static const String apiSportsKey = 'YOUR_API_SPORTS_KEY';
  static const String apiSportsBaseUrl = 'https://v3.football.api-sports.io';
  
  // Paramètres de cache
  static const Duration cacheExpiration = Duration(minutes: 5);
  static const Duration apiTimeout = Duration(seconds: 10);
  
  // Compétitions supportées (IDs Football-Data.org)
  static const Map<String, int> supportedCompetitions = {
    'Premier League': 2021,
    'La Liga': 2014,
    'Bundesliga': 2002,
    'Serie A': 2019,
    'Ligue 1': 2015,
    'Champions League': 2001,
    'World Cup': 2000,
  };
  
  /// Retourne la clé API à utiliser
  static String get apiKey {
    // En production, récupérer depuis les variables d'environnement
    // ou Firebase Remote Config
    return footballDataApiKey;
  }
  
  /// Retourne l'URL de base à utiliser
  static String get baseUrl {
    return footballDataBaseUrl;
  }
  
  /// Vérifie si la configuration API est valide
  static bool get isConfigured {
    return apiKey.isNotEmpty && (apiKey == 'demo' || apiKey != 'YOUR_FOOTBALL_DATA_API_KEY');
  }
}