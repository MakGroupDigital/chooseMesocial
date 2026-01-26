import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 't_b_dgeneral_a_d_m_model.dart';
export 't_b_dgeneral_a_d_m_model.dart';

class TBDgeneralADMWidget extends StatefulWidget {
  const TBDgeneralADMWidget({super.key});

  static String routeName = 'TBDgeneralADM';
  static String routePath = 'tBDgeneralADM';

  @override
  State<TBDgeneralADMWidget> createState() => _TBDgeneralADMWidgetState();
}

class _TBDgeneralADMWidgetState extends State<TBDgeneralADMWidget> {
  late TBDgeneralADMModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TBDgeneralADMModel());
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Colors.red, Colors.redAccent]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('ADMIN', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        const SizedBox(height: 8),
                        Text('Dashboard', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 2),
                        image: DecorationImage(
                          image: currentUserPhoto.isNotEmpty ? NetworkImage(currentUserPhoto) : const AssetImage('assets/images/Sans_titre-4.png') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 32),

                // Stats grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _buildStatCard('Utilisateurs', '2,456', Icons.people, const Color(0xFF19DB8A), '+12%'),
                    _buildStatCard('Athlètes', '1,234', Icons.sports_soccer, Colors.blue, '+8%'),
                    _buildStatCard('Clubs', '156', Icons.groups, Colors.orange, '+5%'),
                    _buildStatCard('Publications', '8,901', Icons.article, Colors.purple, '+23%'),
                  ],
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 32),

                // Quick actions
                Text('Gestion', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                const SizedBox(height: 16),

                _buildActionTile('Utilisateurs', Icons.people, Colors.blue, () => context.pushNamed(ADMutilisateursWidget.routeName)),
                _buildActionTile('Modération', Icons.shield, Colors.red, () => context.pushNamed(ModerationWidget.routeName)),
                _buildActionTile('Publications', Icons.article, Colors.purple, () => context.pushNamed(PubADMWidget.routeName)),
                _buildActionTile('Configuration', Icons.settings, Colors.grey, () => context.pushNamed(ConfigADMWidget.routeName)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(change, style: GoogleFonts.readexPro(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
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
