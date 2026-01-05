import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'reportagehome_model.dart';
export 'reportagehome_model.dart';

class ReportagehomeWidget extends StatefulWidget {
  const ReportagehomeWidget({super.key});

  static String routeName = 'reportagehome';
  static String routePath = 'reportagehome';

  @override
  State<ReportagehomeWidget> createState() => _ReportagehomeWidgetState();
}

class _ReportagehomeWidgetState extends State<ReportagehomeWidget> {
  late ReportagehomeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportagehomeModel());
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(colors: [Colors.red, Colors.redAccent]).createShader(bounds),
                      child: Text('Reportages', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.red, Colors.redAccent]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: 5,
                  itemBuilder: (context, index) => _buildReportageCard(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportageCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: const DecorationImage(
                image: AssetImage('assets/images/Sans_titre-4.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('12:34', style: GoogleFonts.readexPro(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reportage ${index + 1}: Les talents africains', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.white.withOpacity(0.5), size: 16),
                    const SizedBox(width: 4),
                    Text('${(index + 1) * 234} vues', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, color: Colors.white.withOpacity(0.5), size: 16),
                    const SizedBox(width: 4),
                    Text('Il y a ${index + 1} jours', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
