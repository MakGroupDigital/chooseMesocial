import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'redirection_model.dart';
export 'redirection_model.dart';

class RedirectionWidget extends StatefulWidget {
  const RedirectionWidget({super.key});

  static String routeName = 'redirection';
  static String routePath = 'redirection';

  @override
  State<RedirectionWidget> createState() => _RedirectionWidgetState();
}

class _RedirectionWidgetState extends State<RedirectionWidget>
    with TickerProviderStateMixin {
  late RedirectionModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Couleurs du gradient principal (charte graphique ChooseMe)
  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];
  
  // Animation du loader
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RedirectionModel());
    
    // Animation de pulsation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Animation de rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Redirection automatique après 3 secondes
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Animation de progression
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 30));
        if (mounted) {
          setState(() => _progress = i / 100);
        }
      }
      
      // Redirection basée sur le type d'utilisateur
      if (mounted) {
        _redirectUser();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _redirectUser() {
    final String statut = valueOrDefault(currentUserDocument?.statut, '');
    final String etat = valueOrDefault(currentUserDocument?.etat, '');
    final String type = valueOrDefault(currentUserDocument?.type, '');

    if (statut == 'ok' && etat == 'ac') {
      // Compte validé - rediriger vers le tableau de bord approprié
      switch (type) {
        case 'joueur':
          context.pushNamed(AfficheTalentprofilWidget.routeName);
          break;
        case 'recruteur':
          context.pushNamed(TbdmanagereWidget.routeName);
          break;
        case 'journaliste':
          context.pushNamed(TbdpresseWidget.routeName);
          break;
        case 'equipe':
          context.pushNamed(TbclubWidget.routeName);
          break;
        case 'adm':
          context.pushNamed(TBDgeneralADMWidget.routeName);
          break;
        case 'visiteur':
          context.pushNamed(Home8Widget.routeName);
          break;
        default:
          context.pushNamed(ChargementWidget.routeName);
      }
    } else if (statut == 'no' && etat == 'nv') {
      // Nouveau compte - compléter le profil
      switch (type) {
        case 'joueur':
          context.pushNamed(CompleteinfosjouereWidget.routeName);
          break;
        case 'recruteur':
          context.pushNamed(RecruteurinfosWidget.routeName);
          break;
        case 'equipe':
          context.pushNamed(ClubcreationprofilWidget.routeName);
          break;
        case 'journaliste':
          context.pushNamed(PressecreatWidget.routeName);
          break;
        case 'visiteur':
          context.pushNamed(Home8Widget.routeName);
          break;
        default:
          context.pushNamed(ChargementWidget.routeName);
      }
    } else {
      // Autres cas - page de chargement
      context.pushNamed(ChargementWidget.routeName);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            // Background gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _primaryGradient[0],
                    _primaryGradient[1],
                    _primaryGradient[0].withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Cercles décoratifs animés
            _buildDecorativeCircles(),
            // Contenu principal
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedLogo(),
                      const SizedBox(height: 48),
                      _buildProgressSection(theme),
                      const SizedBox(height: 48),
                      _buildManualButton(theme),
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

  Widget _buildDecorativeCircles() {
    return Stack(
      children: [
        // Cercle en haut à droite
        Positioned(
          top: -100,
          right: -100,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 300 + (_pulseController.value * 20),
                height: 300 + (_pulseController.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Cercle en bas à gauche
        Positioned(
          bottom: -80,
          left: -80,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 250 + (_pulseController.value * 15),
                height: 250 + (_pulseController.value * 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Petits cercles flottants
        ..._buildFloatingDots(),
      ],
    );
  }

  List<Widget> _buildFloatingDots() {
    return List.generate(6, (index) {
      final top = 100.0 + (index * 120);
      final left = (index % 2 == 0) ? 50.0 + (index * 30) : null;
      final right = (index % 2 != 0) ? 50.0 + (index * 20) : null;
      
      return Positioned(
        top: top,
        left: left,
        right: right,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 8 + (index * 2),
              height: 8 + (index * 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2 + (_pulseController.value * 0.1)),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildAnimatedLogo() {
    return Column(
      children: [
        // Logo avec animation
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3 + (_pulseController.value * 0.2)),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2 + (_pulseController.value * 0.1)),
                    blurRadius: 30 + (_pulseController.value * 10),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Sans_titre-4.png',
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ).animate().fadeIn(duration: 600.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        ),
        const SizedBox(height: 24),
        // Titre
        Text(
          'ChooseMe',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
      ],
    );
  }

  Widget _buildProgressSection(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icône de redirection animée
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.7)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.sync_rounded,
                    color: _primaryGradient[0],
                    size: 32,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // Titre
          Text(
            'Redirection en cours...',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ).animate(delay: 300.ms).fadeIn(duration: 500.ms),
          const SizedBox(height: 12),
          // Description
          Text(
            'Nous préparons votre espace personnalisé.\nVeuillez patienter quelques instants.',
            textAlign: TextAlign.center,
            style: GoogleFonts.readexPro(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ).animate(delay: 400.ms).fadeIn(duration: 500.ms),
          const SizedBox(height: 28),
          // Barre de progression
          _buildProgressBar(),
          const SizedBox(height: 12),
          // Pourcentage
          Text(
            '${(_progress * 100).toInt()}%',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate(delay: 250.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualButton(FlutterFlowTheme theme) {
    return Column(
      children: [
        Text(
          'Si vous n\'êtes pas redirigé automatiquement',
          textAlign: TextAlign.center,
          style: GoogleFonts.readexPro(
            fontSize: 13,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FFButtonWidget(
            onPressed: () => context.pushNamed(ChargementWidget.routeName),
            text: 'Continuer manuellement',
            icon: Icon(Icons.arrow_forward_rounded, color: _primaryGradient[0], size: 20),
            options: FFButtonOptions(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              color: Colors.transparent,
              textStyle: GoogleFonts.readexPro(
                color: _primaryGradient[0],
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              elevation: 0,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    ).animate(delay: 500.ms).fadeIn(duration: 400.ms);
  }
}
