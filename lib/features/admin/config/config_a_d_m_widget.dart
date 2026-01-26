import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import 'config_a_d_m_model.dart';
export 'config_a_d_m_model.dart';

class ConfigADMWidget extends StatefulWidget {
  const ConfigADMWidget({super.key});

  static String routeName = 'configADM';
  static String routePath = 'configADM';

  @override
  State<ConfigADMWidget> createState() => _ConfigADMWidgetState();
}

class _ConfigADMWidgetState extends State<ConfigADMWidget> {
  late ConfigADMModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _maintenanceMode = false;
  bool _registrationOpen = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfigADMModel());
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
                      child: Text('Configuration', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paramètres généraux', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                      const SizedBox(height: 16),

                      _buildSwitchTile('Mode maintenance', 'Désactiver l\'accès à l\'application', Icons.build, _maintenanceMode, (v) => setState(() => _maintenanceMode = v)),
                      _buildSwitchTile('Inscriptions ouvertes', 'Permettre les nouvelles inscriptions', Icons.person_add, _registrationOpen, (v) => setState(() => _registrationOpen = v)),

                      const SizedBox(height: 32),

                      Text('Base de données', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                      const SizedBox(height: 16),

                      _buildActionTile('Sauvegarder', Icons.backup, Colors.blue, () {}),
                      _buildActionTile('Restaurer', Icons.restore, Colors.orange, () {}),
                      _buildActionTile('Nettoyer le cache', Icons.cleaning_services, Colors.purple, () {}),

                      const SizedBox(height: 32),

                      Text('Notifications', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                      const SizedBox(height: 16),

                      _buildActionTile('Envoyer une notification globale', Icons.notifications_active, const Color(0xFF19DB8A), () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white.withOpacity(0.7), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w500)),
                Text(subtitle, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF19DB8A),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildActionTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
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
            Expanded(child: Text(title, style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w500))),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 16),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
