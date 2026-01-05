import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'connexion_model.dart';
export 'connexion_model.dart';

class ConnexionWidget extends StatefulWidget {
  const ConnexionWidget({super.key});

  static String routeName = 'Connexion';
  static String routePath = 'connexion';

  @override
  State<ConnexionWidget> createState() => _ConnexionWidgetState();
}

class _ConnexionWidgetState extends State<ConnexionWidget>
    with TickerProviderStateMixin {
  late ConnexionModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Couleurs du gradient principal (charte graphique ChooseMe)
  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConnexionModel());
    _model.textFieldmailTextController ??= TextEditingController();
    _model.textFieldmailFocusNode ??= FocusNode();
    _model.textFieldcodeTextController ??= TextEditingController();
    _model.textFieldcodeFocusNode ??= FocusNode();
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
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            // Image de fond
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/Capture_decran_2025-03-07_a_20.39.00.png',
                  ).image,
                ),
              ),
            ),
            // Overlay gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    _primaryGradient[0].withOpacity(0.7),
                    _primaryGradient[0].withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
            // Cercles décoratifs
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _primaryGradient[1].withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _primaryGradient[0].withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Contenu principal
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(theme),
                      const SizedBox(height: 50),
                      _buildLoginForm(theme),
                      const SizedBox(height: 32),
                      _buildSocialLogin(theme),
                      const SizedBox(height: 32),
                      _buildCreateAccount(theme),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Column(
      children: [
        // Logo avec effet glow
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: _primaryGradient[1].withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/Sans_titre-2_(4).png',
              fit: BoxFit.cover,
            ),
          ),
        ).animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        const SizedBox(height: 20),
        // Titre ChooseMe
        Text(
          'ChooseMe',
          style: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
        const SizedBox(height: 8),
        // Sous-titre
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Connexion',
            style: GoogleFonts.readexPro(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildLoginForm(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Champ email
          _buildTextField(
            controller: _model.textFieldmailTextController!,
            focusNode: _model.textFieldmailFocusNode!,
            label: 'Adresse e-mail',
            hint: 'exemple@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 20),
          // Champ mot de passe
          _buildPasswordField().animate(delay: 500.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          // Mot de passe oublié
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.pushNamed(PassforwarWidget.routeName),
              child: Text(
                'Mot de passe oublié ?',
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate(delay: 550.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 28),
          // Bouton connexion
          _buildLoginButton().animate(delay: 600.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    ).animate(delay: 350.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: GoogleFonts.readexPro(
        fontSize: 15,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.readexPro(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.readexPro(
          color: Colors.white.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryGradient[1], width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _model.textFieldcodeTextController,
      focusNode: _model.textFieldcodeFocusNode,
      obscureText: !_model.textFieldcodeVisibility,
      style: GoogleFonts.readexPro(
        fontSize: 15,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        hintText: 'Entrez votre mot de passe',
        labelStyle: GoogleFonts.readexPro(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.readexPro(
          color: Colors.white.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
        ),
        suffixIcon: IconButton(
          onPressed: () => safeSetState(() => 
            _model.textFieldcodeVisibility = !_model.textFieldcodeVisibility
          ),
          icon: Icon(
            _model.textFieldcodeVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white.withOpacity(0.7),
            size: 22,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryGradient[1], width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: _handleLogin,
        text: 'Se connecter',
        icon: Icon(Icons.login_rounded, color: _primaryGradient[0], size: 22),
        options: FFButtonOptions(
          width: double.infinity,
          height: 58,
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          textStyle: GoogleFonts.readexPro(
            color: _primaryGradient[0],
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildSocialLogin(FlutterFlowTheme theme) {
    return Column(
      children: [
        // Séparateur
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ou continuer avec',
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ],
        ).animate(delay: 650.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 24),
        // Boutons sociaux
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                icon: 'assets/images/channels4_profile.jpg',
                label: 'Google',
                onTap: _handleGoogleLogin,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSocialButton(
                icon: 'assets/images/images_(2).png',
                label: 'Apple',
                onTap: _handleAppleLogin,
              ),
            ),
          ],
        ).animate(delay: 700.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                icon,
                width: 26,
                height: 26,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.readexPro(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccount(FlutterFlowTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ?',
          style: GoogleFonts.readexPro(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => context.pushNamed(CreatWidget.routeName),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              'Créer un compte',
              style: GoogleFonts.readexPro(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _primaryGradient[0],
              ),
            ),
          ),
        ),
      ],
    ).animate(delay: 750.ms).fadeIn(duration: 400.ms);
  }

  Future<void> _handleLogin() async {
    GoRouter.of(context).prepareAuthEvent();
    final user = await authManager.signInWithEmail(
      context,
      _model.textFieldmailTextController.text,
      _model.textFieldcodeTextController.text,
    );
    if (user == null) return;
    context.pushNamedAuth(ChargementWidget.routeName, context.mounted);
  }

  Future<void> _handleGoogleLogin() async {
    GoRouter.of(context).prepareAuthEvent();
    final user = await authManager.signInWithGoogle(context);
    if (user == null) return;
    context.goNamedAuth(ChargementWidget.routeName, context.mounted);
  }

  Future<void> _handleAppleLogin() async {
    GoRouter.of(context).prepareAuthEvent();
    final user = await authManager.signInWithApple(context);
    if (user == null) return;
    context.goNamedAuth(ChargementWidget.routeName, context.mounted);
  }
}
