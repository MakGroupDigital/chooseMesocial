import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import 'politique_model.dart';
export 'politique_model.dart';

class PolitiqueWidget extends StatefulWidget {
  const PolitiqueWidget({super.key});

  static String routeName = 'politique';
  static String routePath = 'politique';

  @override
  State<PolitiqueWidget> createState() => _PolitiqueWidgetState();
}

class _PolitiqueWidgetState extends State<PolitiqueWidget> {
  late PolitiqueModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PolitiqueModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E), Color(0xFF0A0A0A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.safePop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF208050), Color(0xFF19DB8A)],
                      ).createShader(bounds),
                      child: Text(
                        'Politique de Confidentialité',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('1. Collecte des données', 'Nous collectons uniquement les données nécessaires au fonctionnement de l\'application, incluant votre nom, email, et informations sportives.'),
                      _buildSection('2. Utilisation des données', 'Vos données sont utilisées pour personnaliser votre expérience, vous connecter avec des recruteurs et améliorer nos services.'),
                      _buildSection('3. Protection des données', 'Nous utilisons des mesures de sécurité avancées pour protéger vos informations personnelles contre tout accès non autorisé.'),
                      _buildSection('4. Partage des données', 'Vos données ne sont jamais vendues. Elles peuvent être partagées avec des recruteurs uniquement avec votre consentement.'),
                      _buildSection('5. Vos droits', 'Vous pouvez à tout moment accéder, modifier ou supprimer vos données personnelles depuis les paramètres de votre compte.'),
                      _buildSection('6. Cookies', 'Nous utilisons des cookies pour améliorer votre expérience de navigation et analyser l\'utilisation de notre plateforme.'),
                      _buildSection('7. Contact', 'Pour toute question concernant cette politique, contactez-nous à privacy@chooseme.app'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(color: const Color(0xFF19DB8A), fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 12),
          Text(content, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.7), fontSize: 14, height: 1.6)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
