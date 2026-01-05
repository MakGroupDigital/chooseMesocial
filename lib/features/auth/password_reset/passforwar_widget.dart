import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'passforwar_model.dart';
export 'passforwar_model.dart';

class PassforwarWidget extends StatefulWidget {
  const PassforwarWidget({super.key});

  static String routeName = 'passforwar';
  static String routePath = 'passforwar';

  @override
  State<PassforwarWidget> createState() => _PassforwarWidgetState();
}

class _PassforwarWidgetState extends State<PassforwarWidget> {
  late PassforwarModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassforwarModel());
    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A0A0A),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E), Color(0xFF0A0A0A)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => context.safePop(),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),

                    const SizedBox(height: 40),

                    // Icon with glow
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF208050), Color(0xFF19DB8A)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF19DB8A).withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),

                    const SizedBox(height: 40),

                    // Title
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF208050), Color(0xFF19DB8A)],
                        ).createShader(bounds),
                        child: Text(
                          _emailSent ? 'Email envoyé !' : 'Mot de passe oublié',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                    const SizedBox(height: 12),

                    // Subtitle
                    Center(
                      child: Text(
                        _emailSent
                            ? 'Vérifiez votre boîte de réception et suivez les instructions pour réinitialiser votre mot de passe.'
                            : 'Entrez votre adresse email pour recevoir un lien de réinitialisation.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.readexPro(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                    const SizedBox(height: 48),

                    if (!_emailSent) ...[
                      // Form container with glassmorphism
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email field
                            _buildInputField(
                              controller: _model.emailTextController!,
                              focusNode: _model.textFieldFocusNode!,
                              label: 'Adresse email',
                              hint: 'votre@email.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 24),

                            // Send button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF208050), Color(0xFF19DB8A)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF19DB8A).withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_model.emailTextController!.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Veuillez entrer votre email'),
                                        backgroundColor: Colors.red.shade400,
                                      ),
                                    );
                                    return;
                                  }
                                  await authManager.resetPassword(
                                    email: _model.emailTextController!.text,
                                    context: context,
                                  );
                                  setState(() => _emailSent = true);
                                },
                                text: 'Envoyer le lien',
                                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                                options: FFButtonOptions(
                                  height: 56,
                                  color: Colors.transparent,
                                  textStyle: GoogleFonts.readexPro(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.1),
                    ] else ...[
                      // Success state
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF19DB8A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF19DB8A).withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF19DB8A),
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Un email a été envoyé à',
                              style: GoogleFonts.readexPro(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _model.emailTextController!.text,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF19DB8A),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),

                      const SizedBox(height: 24),

                      // Resend button
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            await authManager.resetPassword(
                              email: _model.emailTextController!.text,
                              context: context,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Email renvoyé !')),
                            );
                          },
                          child: Text(
                            'Renvoyer l\'email',
                            style: GoogleFonts.readexPro(
                              color: const Color(0xFF19DB8A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Back to login
                    Center(
                      child: TextButton(
                        onPressed: () => context.pushNamed(ConnexionWidget.routeName),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white.withOpacity(0.7),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Retour à la connexion',
                              style: GoogleFonts.readexPro(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.readexPro(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF208050).withOpacity(0.3),
                      const Color(0xFF19DB8A).withOpacity(0.3),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Icon(icon, color: const Color(0xFF19DB8A), size: 22),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  style: GoogleFonts.readexPro(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.readexPro(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
