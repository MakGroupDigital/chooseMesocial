import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'erreur_model.dart';
export 'erreur_model.dart';

class ErreurWidget extends StatefulWidget {
  const ErreurWidget({super.key});

  static String routeName = 'erreur';
  static String routePath = 'erreur';

  @override
  State<ErreurWidget> createState() => _ErreurWidgetState();
}

class _ErreurWidgetState extends State<ErreurWidget> {
  late ErreurModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ErreurModel());
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
                  // Error icon with glow
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red.shade700, Colors.red.shade400],
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 40, spreadRadius: 10),
                      ],
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 72),
                  ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5)).then().shake(hz: 3, duration: 500.ms),

                  const SizedBox(height: 48),

                  // Title
                  Text(
                    'Oups !',
                    style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.red.shade400),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 16),

                  Text(
                    'Une erreur s\'est produite. Veuillez réessayer plus tard.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.readexPro(fontSize: 16, color: Colors.white.withOpacity(0.7), height: 1.5),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                  const SizedBox(height: 48),

                  // Retry button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.red.shade700, Colors.red.shade400]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    child: FFButtonWidget(
                      onPressed: () => context.safePop(),
                      text: 'Réessayer',
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                      options: FFButtonOptions(
                        height: 56,
                        color: Colors.transparent,
                        textStyle: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideY(begin: 0.2),

                  const SizedBox(height: 16),

                  // Home button
                  TextButton(
                    onPressed: () => context.pushNamed(Home8Widget.routeName),
                    child: Text('Retour à l\'accueil', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6))),
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
