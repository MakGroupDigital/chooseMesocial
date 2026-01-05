import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'h_o_m_echoose_model.dart';
export 'h_o_m_echoose_model.dart';

class HOMEchooseWidget extends StatefulWidget {
  const HOMEchooseWidget({super.key});

  static String routeName = 'HOMEchoose';
  static String routePath = 'hOMEchoose';

  @override
  State<HOMEchooseWidget> createState() => _HOMEchooseWidgetState();
}

class _HOMEchooseWidgetState extends State<HOMEchooseWidget> {
  late HOMEchooseModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HOMEchooseModel());
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
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                            boxShadow: [BoxShadow(color: const Color(0xFF19DB8A).withOpacity(0.3), blurRadius: 12)],
                          ),
                          child: ClipOval(child: Image.asset('assets/images/Sans_titre-4.png', fit: BoxFit.cover)),
                        ),
                        const SizedBox(width: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]).createShader(bounds),
                          child: Text('ChooseMe', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pushNamed(NotificationWidget.routeName),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                            child: Stack(
                              children: [
                                const Center(child: Icon(Icons.notifications_outlined, color: Colors.white, size: 22)),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(color: Color(0xFF19DB8A), shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.pushNamed(ProfilUTWidget.routeName),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF19DB8A), width: 2),
                              image: DecorationImage(
                                image: currentUserPhoto.isNotEmpty ? NetworkImage(currentUserPhoto) : const AssetImage('assets/images/Sans_titre-4.png') as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Main content
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    _buildHomeTab(),
                    _buildSearchTab(),
                    _buildMessagesTab(),
                    _buildProfileTab(),
                  ],
                ),
              ),

              // Bottom navigation
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bienvenue,', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 16)),
          Text(currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'Utilisateur', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
          const SizedBox(height: 24),
          _buildQuickAction('Voir le fil d\'actualité', Icons.feed, const Color(0xFF19DB8A), () => context.pushNamed(Home8Widget.routeName)),
          _buildQuickAction('Rechercher des talents', Icons.search, Colors.blue, () => context.pushNamed(SearcheTalentWidget.routeName)),
          _buildQuickAction('Messages', Icons.message, Colors.orange, () => context.pushNamed(MessageWidget.routeName)),
        ],
      ),
    );
  }

  Widget _buildSearchTab() => Center(child: Text('Recherche', style: GoogleFonts.inter(color: Colors.white)));
  Widget _buildMessagesTab() => Center(child: Text('Messages', style: GoogleFonts.inter(color: Colors.white)));
  Widget _buildProfileTab() => Center(child: Text('Profil', style: GoogleFonts.inter(color: Colors.white)));

  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 18),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, 'Accueil'),
          _buildNavItem(1, Icons.search, 'Recherche'),
          _buildNavItem(2, Icons.message, 'Messages'),
          _buildNavItem(3, Icons.person, 'Profil'),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}
