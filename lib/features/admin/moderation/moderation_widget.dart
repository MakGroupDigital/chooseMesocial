import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import 'moderation_model.dart';
export 'moderation_model.dart';

class ModerationWidget extends StatefulWidget {
  const ModerationWidget({super.key});

  static String routeName = 'moderation';
  static String routePath = 'moderation';

  @override
  State<ModerationWidget> createState() => _ModerationWidgetState();
}

class _ModerationWidgetState extends State<ModerationWidget> {
  late ModerationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModerationModel());
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
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(colors: [Colors.red, Colors.redAccent]).createShader(bounds),
                      child: Text('Modération', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Stats
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard('En attente', '12', Icons.pending, Colors.orange)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Signalés', '5', Icons.flag, Colors.red)),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _buildTab('Publications', true),
                    const SizedBox(width: 12),
                    _buildTab('Utilisateurs', false),
                    const SizedBox(width: 12),
                    _buildTab('Commentaires', false),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              // Content
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: 5,
                  itemBuilder: (context, index) => _buildModerationItem(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
              Text(label, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: isSelected ? const LinearGradient(colors: [Colors.red, Colors.redAccent]) : null,
        color: isSelected ? null : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: GoogleFonts.readexPro(color: Colors.white, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, fontSize: 12)),
    );
  }

  Widget _buildModerationItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/images/Sans_titre-4.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Utilisateur ${index + 1}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text('Il y a ${index + 1}h', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Text('En attente', style: GoogleFonts.readexPro(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Contenu de la publication signalée...', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.7))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text('Approuver', style: GoogleFonts.readexPro(color: Colors.green, fontWeight: FontWeight.w600))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text('Rejeter', style: GoogleFonts.readexPro(color: Colors.red, fontWeight: FontWeight.w600))),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn(duration: 300.ms);
  }
}
