import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import 'notification_model.dart';
export 'notification_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  static String routeName = 'notification';
  static String routePath = 'notification';

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with TickerProviderStateMixin {
  late NotificationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildGeneralSection(theme),
                          const SizedBox(height: 20),
                          _buildTypesSection(theme),
                          const SizedBox(height: 20),
                          _buildScheduleSection(theme),
                          const SizedBox(height: 20),
                          _buildSoundSection(theme),
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
                colors: [_primaryGradient[1].withOpacity(0.1), Colors.transparent],
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
                  'Notifications',
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Gérez vos alertes',
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
            child: const Icon(Icons.notifications_active, color: Colors.white, size: 22),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(subtitle, style: GoogleFonts.readexPro(fontSize: 12, color: Colors.white54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(children: children),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildNotificationSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool? value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryGradient[0].withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _primaryGradient[1], size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.readexPro(fontSize: 12, color: Colors.white54)),
              ],
            ),
          ),
          Switch(
            value: value ?? false,
            onChanged: onChanged,
            activeColor: _primaryGradient[1],
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
      title: 'Notifications générales',
      subtitle: 'Activez ou désactivez toutes les notifications',
      icon: Icons.notifications,
      delay: 100,
      children: [
        _buildNotificationSwitch(
          title: 'Activer les notifications',
          subtitle: 'Recevez toutes les alertes de l\'application',
          icon: Icons.notifications_active,
          value: _model.switchListTileValue1,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue1 = val),
        ),
      ],
    );
  }

  Widget _buildTypesSection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'Types de notifications',
      subtitle: 'Choisissez les alertes que vous souhaitez recevoir',
      icon: Icons.category,
      delay: 200,
      children: [
        _buildNotificationSwitch(
          title: 'Messages',
          subtitle: 'Nouveaux messages et conversations',
          icon: Icons.message,
          value: _model.switchListTileValue2,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue2 = val),
        ),
        _buildNotificationSwitch(
          title: 'Mises à jour',
          subtitle: 'Nouvelles fonctionnalités et améliorations',
          icon: Icons.system_update,
          value: _model.switchListTileValue3,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue3 = val),
        ),
        _buildNotificationSwitch(
          title: 'Rappels',
          subtitle: 'Événements et rappels importants',
          icon: Icons.alarm,
          value: _model.switchListTileValue4,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue4 = val),
        ),
        _buildNotificationSwitch(
          title: 'Promotions',
          subtitle: 'Offres spéciales et nouveautés',
          icon: Icons.local_offer,
          value: _model.switchListTileValue5,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue5 = val),
        ),
      ],
    );
  }

  Widget _buildScheduleSection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'Horaires',
      subtitle: 'Définissez quand recevoir les notifications',
      icon: Icons.schedule,
      delay: 300,
      children: [
        _buildNotificationSwitch(
          title: 'Mode Ne pas déranger',
          subtitle: 'Désactiver les notifications la nuit',
          icon: Icons.do_not_disturb_on,
          value: _model.switchListTileValue6,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue6 = val),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plage horaire', style: GoogleFonts.readexPro(fontSize: 14, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text('22:00 - 07:00', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGradient[1])),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryGradient[0].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.edit, color: _primaryGradient[1], size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoundSection(FlutterFlowTheme theme) {
    return _buildSectionCard(
      title: 'Sons et vibrations',
      subtitle: 'Personnalisez les alertes sonores',
      icon: Icons.volume_up,
      delay: 400,
      children: [
        _buildNotificationSwitch(
          title: 'Sons',
          subtitle: 'Activer les sons de notification',
          icon: Icons.music_note,
          value: _model.switchListTileValue7,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue7 = val),
        ),
        _buildNotificationSwitch(
          title: 'Vibrations',
          subtitle: 'Activer les vibrations',
          icon: Icons.vibration,
          value: _model.switchListTileValue8,
          onChanged: (val) => safeSetState(() => _model.switchListTileValue8 = val),
        ),
      ],
    );
  }
}
