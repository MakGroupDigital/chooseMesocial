import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'statutcompte_model.dart';
export 'statutcompte_model.dart';

class StatutcompteWidget extends StatefulWidget {
  const StatutcompteWidget({super.key});

  static String routeName = 'statutcompte';
  static String routePath = 'statutcompte';

  @override
  State<StatutcompteWidget> createState() => _StatutcompteWidgetState();
}

class _StatutcompteWidgetState extends State<StatutcompteWidget> {
  late StatutcompteModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatutcompteModel());
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
                      gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.amber.shade400]),
                      boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 40, spreadRadius: 10)],
                    ),
                    child: const Icon(Icons.hourglass_empty, color: Colors.white, size: 72),
                  ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5)).then().shimmer(duration: 2000.ms),

                  const SizedBox(height: 48),

                  Text('Compte en Attente', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber.shade400)).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 16),

                  Text(
                    'Votre compte est en cours de vérification. Vous recevrez une notification une fois validé.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.readexPro(fontSize: 16, color: Colors.white.withOpacity(0.7), height: 1.5),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                  const SizedBox(height: 32),

                  // Status steps
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        _buildStep('Inscription', true),
                        _buildStep('Vérification email', true),
                        _buildStep('Validation admin', false),
                        _buildStep('Compte actif', false),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                  const SizedBox(height: 32),

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
                      text: 'Continuer en mode limité',
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

  Widget _buildStep(String label, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: completed ? const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]) : null,
              color: completed ? null : Colors.white.withOpacity(0.1),
            ),
            child: Icon(completed ? Icons.check : Icons.circle_outlined, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 16),
          Text(label, style: GoogleFonts.readexPro(color: completed ? Colors.white : Colors.white.withOpacity(0.5), fontWeight: completed ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }
}
