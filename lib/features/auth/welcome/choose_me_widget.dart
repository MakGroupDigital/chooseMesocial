import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'choose_me_model.dart';
export 'choose_me_model.dart';

class ChooseMeWidget extends StatefulWidget {
  const ChooseMeWidget({super.key});

  static String routeName = 'ChooseMe';
  static String routePath = 'chooseMe';

  @override
  State<ChooseMeWidget> createState() => _ChooseMeWidgetState();
}

class _ChooseMeWidgetState extends State<ChooseMeWidget>
    with TickerProviderStateMixin {
  late ChooseMeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Couleurs ChooseMe
  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];
  final List<Color> _accentGradient = const [Color(0xFFFFA130), Color(0xFFFF6B35)];

  final List<SportCategory> _sports = [
    SportCategory(
      name: 'Football',
      description: 'Découvrez les futures stars du football africain',
      image: 'assets/images/people-playing-basketball.jpg',
      icon: Icons.sports_soccer,
    ),
    SportCategory(
      name: 'Basketball',
      description: 'Les talents prometteurs du basketball',
      image: 'assets/images/people-playing-basketball.jpg',
      icon: Icons.sports_basketball,
    ),
    SportCategory(
      name: 'Athlétisme',
      description: 'Les futurs champions de l\'athlétisme',
      image: 'assets/images/Capture_decran_2025-03-07_a_20.04.39.png',
      icon: Icons.directions_run,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChooseMeModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            // Background avec image et overlay
            _buildBackground(size),
            // Contenu principal
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Logo et titre
                      _buildHeader(theme),
                      const SizedBox(height: 40),
                      // Carrousel des sports
                      _buildSportsCarousel(theme),
                      const SizedBox(height: 40),
                      // Stats rapides
                      _buildQuickStats(theme),
                      const SizedBox(height: 40),
                      // Boutons d'action
                      _buildActionButtons(theme),
                      const SizedBox(height: 24),
                      // Footer
                      _buildFooter(theme),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(Size size) {
    return Stack(
      children: [
        // Image de fond
        Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/people-playing-basketball.jpg'),
            ),
          ),
        ),
        // Overlay gradient
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                _primaryGradient[0].withOpacity(0.8),
                Colors.black.withOpacity(0.95),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Cercles décoratifs animés
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _primaryGradient[1].withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 3000.ms),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _accentGradient[0].withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 4000.ms),
        ),
      ],
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Column(
      children: [
        // Logo avec glow effect
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: _primaryGradient),
            boxShadow: [
              BoxShadow(
                color: _primaryGradient[1].withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Sans_titre-4.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ).animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
        const SizedBox(height: 24),
        // Titre principal
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, _primaryGradient[1]],
          ).createShader(bounds),
          child: Text(
            'ChooseMe',
            style: GoogleFonts.inter(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ).animate(delay: 200.ms)
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 8),
        // Sous-titre
        Text(
          'J\'ai un Talent',
          style: GoogleFonts.readexPro(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _primaryGradient[1],
          ),
        ).animate(delay: 300.ms)
          .fadeIn(duration: 500.ms),
        const SizedBox(height: 8),
        Text(
          'La plateforme qui connecte les talents\nsportifs africains au monde',
          textAlign: TextAlign.center,
          style: GoogleFonts.readexPro(
            fontSize: 14,
            color: Colors.white70,
            height: 1.5,
          ),
        ).animate(delay: 400.ms)
          .fadeIn(duration: 500.ms),
      ],
    );
  }

  Widget _buildSportsCarousel(FlutterFlowTheme theme) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _sports.length,
        itemBuilder: (context, index) {
          final sport = _sports[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 12,
              right: index == _sports.length - 1 ? 0 : 0,
            ),
            child: _buildSportCard(sport, index),
          );
        },
      ),
    ).animate(delay: 500.ms)
      .fadeIn(duration: 600.ms)
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildSportCard(SportCategory sport, int index) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primaryGradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              sport.image,
              width: 280,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          // Contenu
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryGradient[1].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _primaryGradient[1].withOpacity(0.5),
                        ),
                      ),
                      child: Icon(
                        sport.icon,
                        color: _primaryGradient[1],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      sport.name,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  sport.description,
                  style: GoogleFonts.readexPro(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Badge numéro
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _primaryGradient),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${index + 1}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('500+', 'Talents', Icons.people),
          _buildStatDivider(),
          _buildStatItem('50+', 'Clubs', Icons.sports),
          _buildStatDivider(),
          _buildStatItem('20+', 'Pays', Icons.public),
        ],
      ),
    ).animate(delay: 600.ms)
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _primaryGradient),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.readexPro(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildActionButtons(FlutterFlowTheme theme) {
    return Column(
      children: [
        // Bouton principal - Commencer
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _accentGradient),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _accentGradient[0].withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FFButtonWidget(
            onPressed: () => context.pushNamed(CreatWidget.routeName),
            text: 'Commencer l\'Aventure',
            icon: const Icon(Icons.rocket_launch, color: Colors.white, size: 22),
            options: FFButtonOptions(
              width: double.infinity,
              height: 60,
              color: Colors.transparent,
              textStyle: GoogleFonts.readexPro(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              elevation: 0,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ).animate(delay: 700.ms)
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        // Bouton secondaire - Connexion
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _primaryGradient[1],
              width: 2,
            ),
          ),
          child: FFButtonWidget(
            onPressed: () => context.pushNamed(ConnexionWidget.routeName),
            text: 'Se Connecter',
            icon: Icon(Icons.login, color: _primaryGradient[1], size: 22),
            options: FFButtonOptions(
              width: double.infinity,
              height: 60,
              color: Colors.transparent,
              textStyle: GoogleFonts.readexPro(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _primaryGradient[1],
              ),
              elevation: 0,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ).animate(delay: 800.ms)
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildFooter(FlutterFlowTheme theme) {
    return Column(
      children: [
        Text(
          'En continuant, vous acceptez nos conditions d\'utilisation',
          textAlign: TextAlign.center,
          style: GoogleFonts.readexPro(
            fontSize: 12,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'By Groupe Tumone Sarlu',
          style: GoogleFonts.readexPro(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.white30,
          ),
        ),
      ],
    ).animate(delay: 900.ms)
      .fadeIn(duration: 500.ms);
  }
}

class SportCategory {
  final String name;
  final String description;
  final String image;
  final IconData icon;

  SportCategory({
    required this.name,
    required this.description,
    required this.image,
    required this.icon,
  });
}
