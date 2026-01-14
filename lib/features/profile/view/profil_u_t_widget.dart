import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'profil_u_t_model.dart';
export 'profil_u_t_model.dart';

class ProfilUTWidget extends StatefulWidget {
  const ProfilUTWidget({super.key});

  static String routeName = 'profilUT';
  static String routePath = 'profilUT';

  @override
  State<ProfilUTWidget> createState() => _ProfilUTWidgetState();
}

class _ProfilUTWidgetState extends State<ProfilUTWidget>
    with TickerProviderStateMixin {
  late ProfilUTModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];
  final List<Color> _accentGradient = const [Color(0xFFFFA130), Color(0xFFFF6B35)];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilUTModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A0A0A),
        body: Stack(
          children: [
            _buildBackground(size),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(theme),
                    _buildProfileCard(theme),
                    const SizedBox(height: 20),
                    _buildStatsSection(theme),
                    const SizedBox(height: 20),
                    _buildInfoSection(theme),
                    const SizedBox(height: 20),
                    _buildActionsSection(theme),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(Size size) {
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _primaryGradient[0].withOpacity(0.3),
                _primaryGradient[1].withOpacity(0.1),
                const Color(0xFF0A0A0A),
              ],
            ),
          ),
        ),
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_primaryGradient[1].withOpacity(0.2), Colors.transparent],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 3000.ms),
        ),
        Positioned(
          top: 100,
          left: -80,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_accentGradient[0].withOpacity(0.15), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.safePop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
          Text(
            'Mon Profil',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ).animate().fadeIn(duration: 400.ms),
          GestureDetector(
            onTap: () => context.pushNamed(ParametreWidget.routeName),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _primaryGradient),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.settings, color: Colors.white, size: 22),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildProfileCard(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: _primaryGradient[0].withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Avatar avec glow
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: _primaryGradient),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGradient[1].withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A0A0A),
                    border: Border.all(color: _primaryGradient[1], width: 3),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/Sans_titre-4.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _accentGradient),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0A0A0A), width: 3),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(height: 20),
            // Nom
            AuthUserStreamWidget(
              builder: (context) => Text(
                currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'Utilisateur',
                style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 6),
            // Email
            Text(
              currentUserEmail,
              style: GoogleFonts.readexPro(fontSize: 14, color: Colors.white54),
            ).animate(delay: 150.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            // Badge type utilisateur
            AuthUserStreamWidget(
              builder: (context) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _primaryGradient),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getTypeIcon(valueOrDefault(currentUserDocument?.type, '')),
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTypeLabel(valueOrDefault(currentUserDocument?.type, '')),
                      style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 20),
            // Bouton modifier profil
            GestureDetector(
              onTap: () => context.pushNamed(ProfilUTedtWidget.routeName),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _primaryGradient[1].withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: _primaryGradient[1], size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Modifier le profil',
                      style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w600, color: _primaryGradient[1]),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatsSection(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
            _buildStatItem('0', 'Publications', Icons.article),
            _buildStatDivider(),
            _buildStatItem('0', 'Vues', Icons.visibility),
            _buildStatDivider(),
            _buildStatItem('0', 'Likes', Icons.favorite),
          ],
        ),
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _primaryGradient),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 10),
        Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: GoogleFonts.readexPro(fontSize: 12, color: Colors.white54)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 50, color: Colors.white.withOpacity(0.1));
  }

  Widget _buildInfoSection(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _primaryGradient),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Text('Informations personnelles', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            _buildInfoRow(Icons.email, 'Email', currentUserEmail),
            AuthUserStreamWidget(
              builder: (context) => _buildInfoRow(Icons.phone, 'Téléphone', currentPhoneNumber.isNotEmpty ? currentPhoneNumber : 'Non renseigné'),
            ),
            AuthUserStreamWidget(
              builder: (context) => _buildInfoRow(Icons.location_on, 'Localisation', valueOrDefault(currentUserDocument?.pays, '').isNotEmpty ? valueOrDefault(currentUserDocument?.pays, '') : 'Non renseigné'),
            ),
            AuthUserStreamWidget(
              builder: (context) => _buildInfoRow(Icons.calendar_today, 'Membre depuis', dateTimeFormat('yMMMd', currentUserDocument?.createdTime)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryGradient[0].withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _primaryGradient[1], size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.readexPro(fontSize: 12, color: Colors.white54)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.readexPro(fontSize: 15, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.account_balance_wallet,
            label: 'Mon Portefeuille',
            onTap: () => context.pushNamed(WalletWidget.routeName),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.emoji_events,
            label: 'Classement',
            onTap: () => context.pushNamed(LeaderboardWidget.routeName),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.notifications,
            label: 'Notifications',
            onTap: () => context.pushNamed(NotificationWidget.routeName),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.help_outline,
            label: 'Aide et support',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.logout,
            label: 'Se déconnecter',
            isDestructive: true,
            onTap: () async {
              GoRouter.of(context).prepareAuthEvent();
              await authManager.signOut();
              GoRouter.of(context).clearRedirectLocation();
              context.goNamedAuth(ChargementWidget.routeName, context.mounted);
            },
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDestructive ? Colors.red.withOpacity(0.3) : Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? Colors.red : _primaryGradient[1], size: 22),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: GoogleFonts.readexPro(fontSize: 16, color: isDestructive ? Colors.red : Colors.white))),
            Icon(Icons.chevron_right, color: isDestructive ? Colors.red.withOpacity(0.5) : Colors.white30),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'joueur': return Icons.sports_soccer;
      case 'recruteur': return Icons.search;
      case 'equipe': return Icons.groups;
      case 'journaliste': return Icons.article;
      case 'visiteur': return Icons.person;
      default: return Icons.person;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'joueur': return 'Athlète';
      case 'recruteur': return 'Recruteur';
      case 'equipe': return 'Club / Équipe';
      case 'journaliste': return 'Journaliste';
      case 'visiteur': return 'Visiteur';
      default: return 'Utilisateur';
    }
  }
}
