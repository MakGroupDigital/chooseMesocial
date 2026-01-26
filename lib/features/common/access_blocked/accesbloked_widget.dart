import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'accesbloked_model.dart';
export 'accesbloked_model.dart';

class AccesblokedWidget extends StatefulWidget {
  const AccesblokedWidget({super.key});

  static String routeName = 'accesbloked';
  static String routePath = 'accesbloked';

  @override
  State<AccesblokedWidget> createState() => _AccesblokedWidgetState();
}

class _AccesblokedWidgetState extends State<AccesblokedWidget>
    with TickerProviderStateMixin {
  late AccesblokedModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];
  final List<Color> _warningGradient = const [Color(0xFFFFA130), Color(0xFFFF6B35)];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccesblokedModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A0A0A),
        body: Stack(
          children: [
            _buildBackground(size),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIcon(),
                    const SizedBox(height: 32),
                    _buildTitle(),
                    const SizedBox(height: 16),
                    _buildDescription(),
                    const SizedBox(height: 32),
                    _buildFeaturesList(),
                    const SizedBox(height: 40),
                    _buildButton(),
                  ],
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
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _warningGradient[0].withOpacity(0.15),
                const Color(0xFF0A0A0A),
                const Color(0xFF0A0A0A),
              ],
            ),
          ),
        ),
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_warningGradient[0].withOpacity(0.1), Colors.transparent],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 3000.ms),
        ),
        Positioned(
          bottom: 100,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_primaryGradient[1].withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: _warningGradient),
        boxShadow: [
          BoxShadow(
            color: _warningGradient[0].withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.videocam_off_rounded,
        color: Colors.white,
        size: 60,
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(begin: const Offset(0.5, 0.5))
      .then()
      .shake(duration: 500.ms, hz: 2);
  }

  Widget _buildTitle() {
    return Text(
      'Accès Limité',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ).animate(delay: 200.ms)
      .fadeIn(duration: 400.ms)
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildDescription() {
    return Text(
      'Seuls les athlètes et joueurs peuvent ajouter des vidéos de performance.',
      textAlign: TextAlign.center,
      style: GoogleFonts.readexPro(
        fontSize: 16,
        color: Colors.white60,
        height: 1.5,
      ),
    ).animate(delay: 300.ms)
      .fadeIn(duration: 400.ms);
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.feed_outlined, 'text': 'Accéder au fil d\'actualité pour découvrir du contenu'},
      {'icon': Icons.person_search_rounded, 'text': 'Rechercher des profils d\'athlètes qui vous correspondent'},
      {'icon': Icons.favorite_border_rounded, 'text': 'Suivre vos athlètes préférés pour voir leurs performances'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _primaryGradient),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Text(
                'Ce que vous pouvez faire',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...features.asMap().entries.map((entry) {
            final feature = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryGradient[0].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: _primaryGradient[1],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      feature['text'] as String,
                      style: GoogleFonts.readexPro(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 400 + entry.key * 100))
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.1, end: 0);
          }),
        ],
      ),
    ).animate(delay: 400.ms)
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _primaryGradient),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _primaryGradient[0].withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: () => context.pushNamed(Home8Widget.routeName),
        text: 'Retourner à l\'accueil',
        icon: const Icon(Icons.home, color: Colors.white, size: 22),
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
      .slideY(begin: 0.2, end: 0);
  }
}
