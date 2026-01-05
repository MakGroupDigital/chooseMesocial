import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'erreurprofil_model.dart';
export 'erreurprofil_model.dart';

class ErreurprofilWidget extends StatefulWidget {
  const ErreurprofilWidget({super.key});

  static String routeName = 'erreurprofil';
  static String routePath = 'erreurprofil';

  @override
  State<ErreurprofilWidget> createState() => _ErreurprofilWidgetState();
}

class _ErreurprofilWidgetState extends State<ErreurprofilWidget> {
  late ErreurprofilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ErreurprofilModel());
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
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.orange.shade400]),
                      boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 40, spreadRadius: 10)],
                    ),
                    child: const Icon(Icons.person_off, color: Colors.white, size: 72),
                  ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5)),

                  const SizedBox(height: 48),

                  Text('Profil Incomplet', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange.shade400)).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 16),

                  Text(
                    'Votre profil n\'est pas complet. Veuillez compléter vos informations pour continuer.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.readexPro(fontSize: 16, color: Colors.white.withOpacity(0.7), height: 1.5),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

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
                      onPressed: () => context.pushNamed(ProfilUTedtWidget.routeName),
                      text: 'Compléter mon profil',
                      icon: const Icon(Icons.edit, color: Colors.white, size: 20),
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

                  TextButton(
                    onPressed: () => context.safePop(),
                    child: Text('Retour', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6))),
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
