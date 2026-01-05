import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/backend/backend.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'a_d_mutilisateurs_model.dart';
export 'a_d_mutilisateurs_model.dart';

class ADMutilisateursWidget extends StatefulWidget {
  const ADMutilisateursWidget({super.key});

  static String routeName = 'ADMutilisateurs';
  static String routePath = 'aDMutilisateurs';

  @override
  State<ADMutilisateursWidget> createState() => _ADMutilisateursWidgetState();
}

class _ADMutilisateursWidgetState extends State<ADMutilisateursWidget> {
  late ADMutilisateursModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ADMutilisateursModel());
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
                      child: Text('Utilisateurs', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    style: GoogleFonts.readexPro(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un utilisateur...',
                      hintStyle: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.4)),
                      prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              // Users list
              Expanded(
                child: StreamBuilder<List<UserRecord>>(
                  stream: queryUserRecord(limit: 50),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF19DB8A)));
                    }
                    final users = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: users.length,
                      itemBuilder: (context, index) => _buildUserTile(users[index], index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTile(UserRecord user, int index) {
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF19DB8A), width: 2),
              image: DecorationImage(
                image: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : const AssetImage('assets/images/Sans_titre-4.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName.isNotEmpty ? user.displayName : 'Utilisateur', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(user.email, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: user.type == 'athlete' ? const Color(0xFF19DB8A).withOpacity(0.2) : Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(user.type.isNotEmpty ? user.type : 'user', style: GoogleFonts.readexPro(color: user.type == 'athlete' ? const Color(0xFF19DB8A) : Colors.blue, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn(duration: 300.ms).slideX(begin: 0.1);
  }
}
