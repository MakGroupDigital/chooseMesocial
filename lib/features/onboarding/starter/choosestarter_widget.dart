import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import 'choosestarter_model.dart';
export 'choosestarter_model.dart';

class ChoosestarterWidget extends StatefulWidget {
  const ChoosestarterWidget({super.key});

  static String routeName = 'choosestarter';
  static String routePath = 'choosestarter';

  @override
  State<ChoosestarterWidget> createState() => _ChoosestarterWidgetState();
}

class _ChoosestarterWidgetState extends State<ChoosestarterWidget>
    with TickerProviderStateMixin {
  late ChoosestarterModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];
  final List<Color> _premiumGradient = const [Color(0xFFFFA130), Color(0xFFFF6B35)];
  
  int _selectedPlan = 1; // 0 = basic, 1 = premium

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChoosestarterModel());
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
        backgroundColor: const Color(0xFF0A0A0A),
        body: Stack(
          children: [
            _buildBackground(size),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(theme),
                      const SizedBox(height: 40),
                      _buildPlanCards(theme),
                      const SizedBox(height: 30),
                      _buildFeaturesList(theme),
                      const SizedBox(height: 30),
                      _buildSubscribeButton(theme),
                      const SizedBox(height: 20),
                      _buildFooter(theme),
                      const SizedBox(height: 40),
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
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _primaryGradient[0].withOpacity(0.2),
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
                colors: [_primaryGradient[1].withOpacity(0.15), Colors.transparent],
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
                colors: [_premiumGradient[0].withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Column(
      children: [
        // Logo avec glow
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: _primaryGradient),
            boxShadow: [
              BoxShadow(
                color: _primaryGradient[1].withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0A0A0A),
              ),
              child: ClipOval(
                child: Image.asset('assets/images/Sans_titre-4.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.5, 0.5)),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(colors: [Colors.white, _primaryGradient[1]]).createShader(bounds),
          child: Text(
            'ChooseMe',
            style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 8),
        Text(
          'Choisissez votre abonnement',
          style: GoogleFonts.readexPro(fontSize: 16, color: Colors.white60),
        ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _premiumGradient[0].withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _premiumGradient[0].withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_fire_department, color: _premiumGradient[0], size: 18),
              const SizedBox(width: 6),
              Text(
                'Offre limitée',
                style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.w600, color: _premiumGradient[0]),
              ),
            ],
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildPlanCards(FlutterFlowTheme theme) {
    return Column(
      children: [
        // Plan Basic
        _buildPlanCard(
          isSelected: _selectedPlan == 0,
          title: 'Basic',
          subtitle: 'Abonnement mensuel',
          price: '5',
          period: '/mois',
          gradient: const [Color(0xFF6A11CB), Color(0xFF2575FC)],
          onTap: () => setState(() => _selectedPlan = 0),
          delay: 400,
        ),
        const SizedBox(height: 16),
        // Plan Premium
        _buildPlanCard(
          isSelected: _selectedPlan == 1,
          title: 'Premium',
          subtitle: 'Abonnement annuel',
          price: '50',
          period: '/an',
          gradient: _primaryGradient,
          badge: 'ÉCONOMISEZ 17%',
          isPopular: true,
          onTap: () => setState(() => _selectedPlan = 1),
          delay: 500,
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required bool isSelected,
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required List<Color> gradient,
    String? badge,
    bool isPopular = false,
    required VoidCallback onTap,
    int delay = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: gradient) : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: gradient[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ] : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.readexPro(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: gradient[0],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.readexPro(
                        fontSize: 14,
                        color: isSelected ? Colors.white70 : Colors.white54,
                      ),
                    ),
                  ],
                ),
                // Prix
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isSelected ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '\$$price',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        period,
                        style: GoogleFonts.readexPro(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isPopular) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.star, color: _premiumGradient[0], size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Recommandé',
                    style: GoogleFonts.readexPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _premiumGradient[0],
                    ),
                  ),
                ],
              ),
            ],
            // Indicateur de sélection
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSelected ? 'Sélectionné' : 'Sélectionner',
                    style: GoogleFonts.readexPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay))
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildFeaturesList(FlutterFlowTheme theme) {
    final features = [
      {'icon': Icons.sports_soccer, 'text': 'Accès à toutes les fonctionnalités'},
      {'icon': Icons.support_agent, 'text': 'Support client prioritaire'},
      {'icon': Icons.update, 'text': 'Mises à jour régulières'},
      {'icon': Icons.visibility, 'text': 'Visibilité maximale'},
      {'icon': Icons.connect_without_contact, 'text': 'Contact direct avec les recruteurs'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inclus dans votre abonnement',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ...features.asMap().entries.map((entry) {
            final feature = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _primaryGradient),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(feature['icon'] as IconData, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      feature['text'] as String,
                      style: GoogleFonts.readexPro(fontSize: 14, color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  Icon(Icons.check, color: _primaryGradient[1], size: 20),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 600 + entry.key * 100))
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.1, end: 0);
          }),
        ],
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 500.ms);
  }

  Widget _buildSubscribeButton(FlutterFlowTheme theme) {
    final isBasic = _selectedPlan == 0;
    final gradient = isBasic ? const [Color(0xFF6A11CB), Color(0xFF2575FC)] : _primaryGradient;
    final paymentUrl = isBasic 
      ? 'https://www.paypal.com/ncp/payment/APKYF38U9WF58'
      : 'https://www.paypal.com/ncp/payment/APKYF38U9WF58';

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: () async {
          unawaited(() async {
            await launchURL(paymentUrl);
          }());
        },
        text: isBasic ? 'S\'abonner à 5\$/mois' : 'S\'abonner à 50\$/an',
        icon: const Icon(Icons.rocket_launch, color: Colors.white, size: 22),
        options: FFButtonOptions(
          width: double.infinity,
          height: 60,
          color: Colors.transparent,
          textStyle: GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          elevation: 0,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ).animate(delay: 1000.ms)
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildFooter(FlutterFlowTheme theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, color: Colors.white38, size: 16),
            const SizedBox(width: 6),
            Text(
              'Paiement sécurisé via PayPal',
              style: GoogleFonts.readexPro(fontSize: 12, color: Colors.white38),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Annulez à tout moment',
          style: GoogleFonts.readexPro(fontSize: 12, color: Colors.white30),
        ),
      ],
    ).animate(delay: 1100.ms).fadeIn(duration: 400.ms);
  }
}
