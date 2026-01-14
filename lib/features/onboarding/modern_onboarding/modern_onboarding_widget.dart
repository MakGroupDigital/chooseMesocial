import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'modern_onboarding_model.dart';
export 'modern_onboarding_model.dart';

class ModernOnboardingWidget extends StatefulWidget {
  const ModernOnboardingWidget({super.key});

  static String routeName = 'modernOnboarding';
  static String routePath = 'onboarding';

  @override
  State<ModernOnboardingWidget> createState() => _ModernOnboardingWidgetState();
}

class _ModernOnboardingWidgetState extends State<ModernOnboardingWidget>
    with TickerProviderStateMixin {
  late ModernOnboardingModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Découvre ton Talent',
      subtitle: 'Montre au monde ce que tu sais faire',
      description:
          'ChooseMe connecte les jeunes talents sportifs africains avec les recruteurs et clubs du monde entier.',
      icon: Icons.sports_soccer,
      gradient: const [Color(0xFF208050), Color(0xFF19DB8A)],
      image: 'assets/images/people-playing-basketball.jpg',
    ),
    OnboardingPage(
      title: 'Connecte-toi',
      subtitle: 'Avec les meilleurs recruteurs',
      description:
          'Des centaines de clubs et recruteurs professionnels recherchent activement de nouveaux talents comme toi.',
      icon: Icons.connect_without_contact,
      gradient: const [Color(0xFF36B4FF), Color(0xFF6A11CB)],
      image: 'assets/images/childrens-playing-football.jpg',
    ),
    OnboardingPage(
      title: 'Réalise tes Rêves',
      subtitle: 'Ta carrière commence ici',
      description:
          'Crée ton profil, partage tes performances et laisse les opportunités venir à toi.',
      icon: Icons.emoji_events,
      gradient: const [Color(0xFFFFA130), Color(0xFFFF6B35)],
      image: 'assets/images/Capture_decran_2025-03-07_a_20.04.39.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModernOnboardingModel());
    _pageController = PageController();
  }

  @override
  void dispose() {
    _model.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      context.pushNamed(CreatWidget.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Stack(
            children: [
              // Background gradient animé
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _pages[_currentPage].gradient[0].withOpacity(0.1),
                      _pages[_currentPage].gradient[1].withOpacity(0.05),
                      theme.primaryBackground,
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
              
              Column(
                children: [
                  // Header avec logo et skip
                  _buildHeader(theme),
                  
                  // PageView principal
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _buildPage(_pages[index], theme, index);
                      },
                    ),
                  ),
                  
                  // Bottom section avec indicateurs et boutons
                  _buildBottomSection(theme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primary, theme.secondary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/Sans_titre-4.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'ChooseMe',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryText,
                ),
              ),
            ],
          ),
          
          // Skip button
          TextButton(
            onPressed: () => context.pushNamed(CreatWidget.routeName),
            child: Text(
              'Passer',
              style: GoogleFonts.readexPro(
                color: theme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, FlutterFlowTheme theme, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image avec effet glassmorphism
          _buildImageCard(page, theme, index),
          
          const SizedBox(height: 40),
          
          // Textes
          _buildTexts(page, theme, index),
        ],
      ),
    );
  }

  Widget _buildImageCard(OnboardingPage page, FlutterFlowTheme theme, int index) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: page.gradient[0].withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image de fond
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              page.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  page.gradient[0].withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Icône flottante
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                page.icon,
                color: Colors.white,
                size: 32,
              ),
            ).animate(delay: Duration(milliseconds: 300 * index))
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.5, 0.5)),
          ),
          
          // Badge numéro
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                '${index + 1}/${_pages.length}',
                style: GoogleFonts.inter(
                  color: page.gradient[0],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 100 * index))
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildTexts(OnboardingPage page, FlutterFlowTheme theme, int index) {
    return Column(
      children: [
        // Titre principal
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: page.gradient,
          ).createShader(bounds),
          child: Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ).animate(delay: Duration(milliseconds: 200 + 100 * index))
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        // Sous-titre
        Text(
          page.subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.readexPro(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.primaryText.withOpacity(0.8),
          ),
        ).animate(delay: Duration(milliseconds: 300 + 100 * index))
          .fadeIn(duration: 500.ms),
        
        const SizedBox(height: 16),
        
        // Description
        Text(
          page.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.readexPro(
            fontSize: 15,
            color: theme.secondaryText,
            height: 1.5,
          ),
        ).animate(delay: Duration(milliseconds: 400 + 100 * index))
          .fadeIn(duration: 500.ms),
      ],
    );
  }

  Widget _buildBottomSection(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        children: [
          // Page indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: _pages[_currentPage].gradient[0],
              dotColor: theme.alternate,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 4,
              spacing: 8,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Boutons
          Row(
            children: [
              // Bouton connexion
              Expanded(
                child: FFButtonWidget(
                  onPressed: () => context.pushNamed(ConnexionWidget.routeName),
                  text: 'Connexion',
                  options: FFButtonOptions(
                    height: 56,
                    padding: const EdgeInsets.all(8),
                    color: theme.secondaryBackground,
                    textStyle: GoogleFonts.readexPro(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: theme.alternate,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Bouton principal
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _pages[_currentPage].gradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _pages[_currentPage].gradient[0].withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: FFButtonWidget(
                    onPressed: _nextPage,
                    text: _currentPage == _pages.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    icon: Icon(
                      _currentPage == _pages.length - 1
                          ? Icons.rocket_launch
                          : Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                    options: FFButtonOptions(
                      height: 56,
                      padding: const EdgeInsets.all(8),
                      color: Colors.transparent,
                      textStyle: GoogleFonts.readexPro(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Texte légal
          Text(
            'En continuant, vous acceptez nos conditions d\'utilisation',
            textAlign: TextAlign.center,
            style: GoogleFonts.readexPro(
              fontSize: 12,
              color: theme.secondaryText.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final String image;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.image,
  });
}
