import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/backend/backend.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'affiche_talent2_model.dart';
export 'affiche_talent2_model.dart';

class AfficheTalent2Widget extends StatefulWidget {
  const AfficheTalent2Widget({super.key, this.userRef});

  final DocumentReference? userRef;
  static String routeName = 'afficheTalent2';
  static String routePath = 'afficheTalent2';

  @override
  State<AfficheTalent2Widget> createState() => _AfficheTalent2WidgetState();
}

class _AfficheTalent2WidgetState extends State<AfficheTalent2Widget> {
  late AfficheTalent2Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AfficheTalent2Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserRecord>(
      stream: UserRecord.getDocument(widget.userRef!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A0A0A),
            body: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              ),
            ),
          );
        }
        final user = snapshot.data!;
        return _buildContent(user);
      },
    );
  }

  Widget _buildContent(UserRecord user) {
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
                // Header with back button
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.share, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                // Profile image with glow
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
                        image: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : const AssetImage('assets/images/Sans_titre-4.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),

                const SizedBox(height: 20),

                // Name and sport
                Text(user.displayName.isNotEmpty ? user.displayName : 'Talent', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(user.sport.isNotEmpty ? user.sport : 'Football', style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600)),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white.withOpacity(0.6), size: 16),
                    const SizedBox(width: 4),
                    Text(user.pays.isNotEmpty ? user.pays : 'Afrique', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6))),
                  ],
                ),

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
                        _buildStat('4.8', 'Note', Icons.star, const Color(0xFFFFD700)),
                        Container(width: 1, height: 50, color: Colors.white.withOpacity(0.1)),
                        _buildStat('23', 'Matchs', Icons.sports_soccer, const Color(0xFF19DB8A)),
                        Container(width: 1, height: 50, color: Colors.white.withOpacity(0.1)),
                        _buildStat('12', 'Buts', Icons.emoji_events, Colors.orange),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                const SizedBox(height: 24),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: const Color(0xFF19DB8A).withOpacity(0.3), blurRadius: 15)],
                          ),
                          child: FFButtonWidget(
                            onPressed: () => context.pushNamed(ChatPageWidget.routeName),
                            text: 'Contacter',
                            icon: const Icon(Icons.message, color: Colors.white, size: 20),
                            options: FFButtonOptions(
                              height: 56,
                              color: Colors.transparent,
                              textStyle: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.favorite_border, color: Colors.white),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

                const SizedBox(height: 32),

                // Bio section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('À propos', style: GoogleFonts.inter(color: const Color(0xFF19DB8A), fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 12),
                        Text(
                          'Jeune talent passionné par le sport, je cherche à développer ma carrière et atteindre le plus haut niveau.',
                          style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.7), height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        Text(label, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 12)),
      ],
    );
  }
}
