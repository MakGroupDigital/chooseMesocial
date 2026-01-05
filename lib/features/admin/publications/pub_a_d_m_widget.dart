import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import 'pub_a_d_m_model.dart';
export 'pub_a_d_m_model.dart';

class PubADMWidget extends StatefulWidget {
  const PubADMWidget({super.key});

  static String routeName = 'pubADM';
  static String routePath = 'pubADM';

  @override
  State<PubADMWidget> createState() => _PubADMWidgetState();
}

class _PubADMWidgetState extends State<PubADMWidget> {
  late PubADMModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PubADMModel());
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
                      shaderCallback: (bounds) => const LinearGradient(colors: [Colors.purple, Colors.purpleAccent]).createShader(bounds),
                      child: Text('Publications', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Stats
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard('Total', '8,901', Icons.article, Colors.purple)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Aujourd\'hui', '45', Icons.today, const Color(0xFF19DB8A))),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              // Publications list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 10,
                  itemBuilder: (context, index) => _buildPublicationTile(index),
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

  Widget _buildPublicationTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.1),
              image: const DecorationImage(image: AssetImage('assets/images/Sans_titre-4.png'), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Publication #${index + 1}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.white.withOpacity(0.5), size: 14),
                    const SizedBox(width: 4),
                    Text('${(index + 1) * 123} vues', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                    const SizedBox(width: 12),
                    Icon(Icons.favorite, color: Colors.white.withOpacity(0.5), size: 14),
                    const SizedBox(width: 4),
                    Text('${(index + 1) * 45} likes', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.5)),
            color: const Color(0xFF1A1A2E),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Voir', style: GoogleFonts.readexPro(color: Colors.white))),
              PopupMenuItem(child: Text('Supprimer', style: GoogleFonts.readexPro(color: Colors.red))),
            ],
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn(duration: 300.ms);
  }
}
