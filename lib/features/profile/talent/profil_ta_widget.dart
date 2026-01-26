import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profil_ta_model.dart';
export 'profil_ta_model.dart';

class ProfilTaWidget extends StatefulWidget {
  const ProfilTaWidget({super.key});

  static String routeName = 'profilTa';
  static String routePath = 'profilTa';

  @override
  State<ProfilTaWidget> createState() => _ProfilTaWidgetState();
}

class _ProfilTaWidgetState extends State<ProfilTaWidget> {
  late ProfilTaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilTaModel());
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                      GestureDetector(
                        onTap: () => context.pushNamed(ProfilUTedtWidget.routeName),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.edit, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                // Profile image
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF19DB8A).withOpacity(0.4), blurRadius: 30)],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: currentUserPhoto.isNotEmpty ? NetworkImage(currentUserPhoto) : const AssetImage('assets/images/Sans_titre-4.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),

                const SizedBox(height: 20),

                Text(currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'Mon Profil', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Athlète', style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600)),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 32),

                // Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('12', 'Publications'),
                        Container(width: 1, height: 50, color: Colors.white.withOpacity(0.1)),
                        _buildStat('1.2K', 'Vues'),
                        Container(width: 1, height: 50, color: Colors.white.withOpacity(0.1)),
                        _buildStat('45', 'Contacts'),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                const SizedBox(height: 24),

                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildActionTile('Mes publications', Icons.article, const Color(0xFF19DB8A), () {}),
                      _buildActionTile('Mes vidéos', Icons.videocam, Colors.red, () {}),
                      _buildActionTile('Statistiques', Icons.bar_chart, Colors.blue, () {}),
                      _buildActionTile('Paramètres', Icons.settings, Colors.grey, () => context.pushNamed(ParametreWidget.routeName)),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
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

  Widget _buildActionTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16))),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 16),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
