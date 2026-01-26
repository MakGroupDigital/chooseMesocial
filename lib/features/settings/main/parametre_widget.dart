import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'parametre_model.dart';
export 'parametre_model.dart';

class ParametreWidget extends StatefulWidget {
  const ParametreWidget({super.key});

  static String routeName = 'parametre';
  static String routePath = 'parametre';

  @override
  State<ParametreWidget> createState() => _ParametreWidgetState();
}

class _ParametreWidgetState extends State<ParametreWidget>
    with TickerProviderStateMixin {
  late ParametreModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ParametreModel());
    _model.switchValue1 = true;
    _model.switchValue2 = true;
    _model.switchValue3 = true;
    _model.switchValue4 = true;
    _model.switchValue5 = true;
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A0A0A),
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(theme),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildGeneralSection(theme),
                          const SizedBox(height: 20),
                          _buildLanguageSection(theme),
                          const SizedBox(height: 20),
                          _buildPrivacySection(theme),
                          const SizedBox(height: 20),
                          _buildAccountSection(theme),
                          const SizedBox(height: 20),
                          _buildAboutSection(theme),
                          const SizedBox(height: 40),
                          _buildLogoutButton(theme),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryGradient[0].withOpacity(0.15),
                const Color(0xFF0A0A0A),
                const Color(0xFF0A0A0A),
              ],
            ),
          ),
        ),
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _primaryGradient[1].withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Row(
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paramètres',
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Personnalisez votre expérience',
                  style: GoogleFonts.readexPro(fontSize: 14, color: _primaryGradient[1]),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _primaryGradient),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 22),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    int delay = 0,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _primaryGradient),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(children: children),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSwitchRow(String label, bool? value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.readexPro(fontSize: 15, color: Colors.white.withOpacity(0.9))),
          Switch(
            value: value ?? false,
            onChanged: onChanged,
            activeThumbColor: _primaryGradient[1],
            activeTrackColor: _primaryGradient[0].withOpacity(0.5),
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white12,
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'Préférences générales',
      icon: Icons.tune,
      delay: 100,
      children: [
        _buildSwitchRow('Notifications', _model.switchValue1, (val) => safeSetState(() => _model.switchValue1 = val)),
        _buildDivider(),
        _buildSwitchRow('Mode sombre', _model.switchValue2, (val) {
          safeSetState(() => _model.switchValue2 = val);
          setDarkModeSetting(context, val ? ThemeMode.dark : ThemeMode.light);
        }),
        _buildDivider(),
        _buildSwitchRow('Sons', _model.switchValue3, (val) => safeSetState(() => _model.switchValue3 = val)),
      ],
    );
  }

  Widget _buildLanguageSection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'Langue et région',
      icon: Icons.language,
      delay: 200,
      children: [
        _buildDropdownField(
          label: 'Langue',
          icon: Icons.translate,
          options: const ['Français', 'English', 'Español'],
          value: _model.dropDownValue1,
          onChanged: (val) => safeSetState(() => _model.dropDownValue1 = val),
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'Pays',
          icon: Icons.public,
          options: const ['France', 'Belgique', 'RD Congo', 'Cameroun', 'Sénégal'],
          value: _model.dropDownValue2,
          onChanged: (val) => safeSetState(() => _model.dropDownValue2 = val),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> options,
    String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: Colors.white38, size: 20),
              const SizedBox(width: 12),
              Text(label, style: GoogleFonts.readexPro(color: Colors.white38)),
            ],
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: _primaryGradient[1]),
          dropdownColor: const Color(0xFF1A1A1A),
          isExpanded: true,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: GoogleFonts.readexPro(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPrivacySection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'Confidentialité',
      icon: Icons.shield,
      delay: 300,
      children: [
        _buildSwitchRow('Profil public', _model.switchValue4, (val) => safeSetState(() => _model.switchValue4 = val)),
        _buildDivider(),
        _buildSwitchRow('Partage de données', _model.switchValue5, (val) => safeSetState(() => _model.switchValue5 = val)),
      ],
    );
  }

  Widget _buildAccountSection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'Compte',
      icon: Icons.person,
      delay: 400,
      children: [
        _buildActionButton(label: 'Modifier le mot de passe', icon: Icons.lock_outline, onTap: () {}),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Supprimer le compte',
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: () async {
            await authManager.deleteUser(context);
            if (context.mounted) context.goNamedAuth(ChargementWidget.routeName, context.mounted);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required VoidCallback onTap, bool isDestructive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDestructive ? Colors.red.withOpacity(0.3) : Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? Colors.red : Colors.white70, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: GoogleFonts.readexPro(fontSize: 15, color: isDestructive ? Colors.red : Colors.white))),
            Icon(Icons.chevron_right, color: isDestructive ? Colors.red.withOpacity(0.5) : Colors.white30),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'À propos',
      icon: Icons.info_outline,
      delay: 500,
      children: [
        _buildInfoRow('Version', '1.0.0'),
        _buildDivider(),
        _buildActionButton(label: 'Conditions d\'utilisation', icon: Icons.description_outlined, onTap: () => context.pushNamed(PolitiqueWidget.routeName)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.readexPro(fontSize: 15, color: Colors.white.withOpacity(0.9))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(gradient: LinearGradient(colors: _primaryGradient), borderRadius: BorderRadius.circular(20)),
            child: Text(value, style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Divider(color: Colors.white.withOpacity(0.1), height: 1));

  Widget _buildLogoutButton(FlutterFlowTheme theme) {
    return GestureDetector(
      onTap: () async {
        GoRouter.of(context).prepareAuthEvent();
        await authManager.signOut();
        GoRouter.of(context).clearRedirectLocation();
        context.goNamedAuth(ChargementWidget.routeName, context.mounted);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Colors.red, size: 22),
            const SizedBox(width: 12),
            Text('Se déconnecter', style: GoogleFonts.readexPro(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red)),
          ],
        ),
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }
}
