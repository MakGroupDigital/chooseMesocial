import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'pubsucces_model.dart';
export 'pubsucces_model.dart';

class PubsuccesWidget extends StatefulWidget {
  const PubsuccesWidget({super.key});

  static String routeName = 'pubsucces';
  static String routePath = 'pubsucces';

  @override
  State<PubsuccesWidget> createState() => _PubsuccesWidgetState();
}

class _PubsuccesWidgetState extends State<PubsuccesWidget> {
  late PubsuccesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PubsuccesModel());
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon with confetti effect
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                      boxShadow: [BoxShadow(color: const Color(0xFF19DB8A).withOpacity(0.5), blurRadius: 40, spreadRadius: 10)],
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 72),
                  ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5)),

                  const SizedBox(height: 48),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]).createShader(bounds),
                    child: Text('Publication Réussie !', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 16),

                  Text(
                    'Votre publication est maintenant visible par la communauté ChooseMe.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.readexPro(fontSize: 16, color: Colors.white.withOpacity(0.7), height: 1.5),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                  const SizedBox(height: 48),

                  // Stats preview
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('0', 'Vues'),
                        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                        _buildStat('0', 'Likes'),
                        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                        _buildStat('0', 'Partages'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                  const SizedBox(height: 48),

                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFF19DB8A).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    child: FFButtonWidget(
                      onPressed: () => context.pushNamed(Home8Widget.routeName),
                      text: 'Voir le fil d\'actualité',
                      icon: const Icon(Icons.home, color: Colors.white, size: 20),
                      options: FFButtonOptions(
                        height: 56,
                        color: Colors.transparent,
                        textStyle: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(color: const Color(0xFF19DB8A), fontWeight: FontWeight.bold, fontSize: 24)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 12)),
      ],
    );
  }
}
