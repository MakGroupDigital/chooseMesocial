import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'choisirtype_model.dart';
export 'choisirtype_model.dart';

class ChoisirtypeWidget extends StatefulWidget {
  const ChoisirtypeWidget({super.key});

  static String routeName = 'choisirtype';
  static String routePath = 'choisirtype';

  @override
  State<ChoisirtypeWidget> createState() => _ChoisirtypeWidgetState();
}

class _ChoisirtypeWidgetState extends State<ChoisirtypeWidget> {
  late ChoisirtypeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedType;

  final List<_UserType> _types = [
    _UserType(id: 'athlete', title: 'Athlète', subtitle: 'Je suis un talent sportif', icon: Icons.sports_soccer, color: const Color(0xFF19DB8A)),
    _UserType(id: 'recruteur', title: 'Recruteur', subtitle: 'Je recherche des talents', icon: Icons.search, color: Colors.blue),
    _UserType(id: 'club', title: 'Club / Équipe', subtitle: 'Je représente un club', icon: Icons.groups, color: Colors.orange),
    _UserType(id: 'presse', title: 'Presse', subtitle: 'Je suis journaliste sportif', icon: Icons.newspaper, color: Colors.purple),
    _UserType(id: 'visiteur', title: 'Visiteur', subtitle: 'Je veux juste explorer', icon: Icons.visibility, color: Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChoisirtypeModel());
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                GestureDetector(
                  onTap: () => context.safePop(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),

                const SizedBox(height: 32),

                // Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF208050), Color(0xFF19DB8A)],
                  ).createShader(bounds),
                  child: Text(
                    'Qui êtes-vous ?',
                    style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 8),

                Text(
                  'Choisissez votre profil pour personnaliser votre expérience',
                  style: GoogleFonts.readexPro(fontSize: 16, color: Colors.white.withOpacity(0.7)),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                const SizedBox(height: 32),

                // Type cards
                Expanded(
                  child: ListView.builder(
                    itemCount: _types.length,
                    itemBuilder: (context, index) {
                      final type = _types[index];
                      final isSelected = _selectedType == type.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = type.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isSelected ? type.color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? type.color : Colors.white.withOpacity(0.1),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected ? [BoxShadow(color: type.color.withOpacity(0.2), blurRadius: 20)] : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: type.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(type.icon, color: type.color, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(type.title, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                                    const SizedBox(height: 4),
                                    Text(type.subtitle, style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                                  ],
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? type.color : Colors.white.withOpacity(0.3), width: 2),
                                  color: isSelected ? type.color : Colors.transparent,
                                ),
                                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn(duration: 400.ms).slideX(begin: 0.1);
                    },
                  ),
                ),

                // Continue button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedType != null
                        ? const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)])
                        : null,
                    color: _selectedType == null ? Colors.white.withOpacity(0.1) : null,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _selectedType != null
                        ? [BoxShadow(color: const Color(0xFF19DB8A).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))]
                        : null,
                  ),
                  child: FFButtonWidget(
                    onPressed: _selectedType != null ? () => context.pushNamed(CreatWidget.routeName) : null,
                    text: 'Continuer',
                    icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    options: FFButtonOptions(
                      height: 56,
                      color: Colors.transparent,
                      textStyle: GoogleFonts.readexPro(color: Colors.white.withOpacity(_selectedType != null ? 1 : 0.5), fontWeight: FontWeight.w600, fontSize: 16),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserType {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  _UserType({required this.id, required this.title, required this.subtitle, required this.icon, required this.color});
}
