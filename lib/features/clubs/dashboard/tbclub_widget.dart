import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tbclub_model.dart';
export 'tbclub_model.dart';

class TbclubWidget extends StatefulWidget {
  const TbclubWidget({super.key});

  static String routeName = 'tbclub';
  static String routePath = 'tbclub';

  @override
  State<TbclubWidget> createState() => _TbclubWidgetState();
}

class _TbclubWidgetState extends State<TbclubWidget> {
  late TbclubModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TbclubModel());
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bienvenue,', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                        Text(currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'Club', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF19DB8A), width: 2),
                        image: DecorationImage(
                          image: currentUserPhoto.isNotEmpty ? NetworkImage(currentUserPhoto) : const AssetImage('assets/images/Sans_titre-4.png') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 32),

                // Stats cards
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Joueurs', '24', Icons.people, const Color(0xFF19DB8A))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Matchs', '12', Icons.sports_soccer, Colors.orange)),
                  ],
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _buildStatCard('Victoires', '8', Icons.emoji_events, const Color(0xFFFFD700))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Candidatures', '15', Icons.inbox, Colors.blue)),
                  ],
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 32),

                // Quick actions
                Text('Gestion du club', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                const SizedBox(height: 16),

                _buildActionTile('Rechercher des talents', Icons.search, const Color(0xFF19DB8A), () => context.pushNamed(SearcheTalentWidget.routeName)),
                _buildActionTile('Gérer l\'équipe', Icons.groups, Colors.blue, () {}),
                _buildActionTile('Calendrier', Icons.calendar_today, Colors.purple, () {}),
                _buildActionTile('Paramètres', Icons.settings, Colors.grey, () => context.pushNamed(ParametreWidget.routeName)),
              ],
            ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
          Text(label, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 12)),
        ],
      ),
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
