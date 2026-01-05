import '/app_state.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/backend/backend.dart';
import '/core/flutter_flow/flutter_flow_choice_chips.dart';
import '/core/flutter_flow/flutter_flow_drop_down.dart';
import '/core/flutter_flow/flutter_flow_icon_button.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/core/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'creat_model.dart';
export 'creat_model.dart';

class CreatWidget extends StatefulWidget {
  const CreatWidget({super.key});

  static String routeName = 'creat';
  static String routePath = 'creat';

  @override
  State<CreatWidget> createState() => _CreatWidgetState();
}

class _CreatWidgetState extends State<CreatWidget>
    with TickerProviderStateMixin {
  late CreatModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Couleurs du gradient principal (charte graphique ChooseMe)
  final List<Color> _primaryGradient = const [Color(0xFF208050), Color(0xFF19DB8A)];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatModel());
    _model.nomTextController ??= TextEditingController();
    _model.nomFocusNode ??= FocusNode();
    _model.mailTextController ??= TextEditingController();
    _model.mailFocusNode ??= FocusNode();
    _model.telTextController ??= TextEditingController();
    _model.telFocusNode ??= FocusNode();
    _model.codeTextController ??= TextEditingController();
    _model.codeFocusNode ??= FocusNode();
    _model.confirmeTextController ??= TextEditingController();
    _model.confirmeFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // Background gradient animé
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _primaryGradient[0].withOpacity(0.1),
                    _primaryGradient[1].withOpacity(0.05),
                    theme.primaryBackground,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
            // Cercles décoratifs
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
                      _primaryGradient[0].withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
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
            // Contenu principal
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(theme),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildHeroSection(theme),
                            const SizedBox(height: 32),
                            _buildFormSection(theme),
                            const SizedBox(height: 24),
                            _buildFooterSection(theme),
                            const SizedBox(height: 32),
                          ],
                        ),
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

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton retour avec style moderne
          Container(
            decoration: BoxDecoration(
              color: theme.secondaryBackground.withOpacity(0.8),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FlutterFlowIconButton(
              borderRadius: 14,
              buttonSize: 48,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.primaryText,
                size: 22,
              ),
              onPressed: () => context.safePop(),
            ),
          ),
          // Logo et titre
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: _primaryGradient),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryGradient[0].withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/Sans_titre-4.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ChooseMe',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(width: 48), // Pour équilibrer le layout
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildHeroSection(FlutterFlowTheme theme) {
    return Column(
      children: [
        // Avatar/Logo animé
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _primaryGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: _primaryGradient[0].withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_rounded,
            color: Colors.white,
            size: 48,
          ),
        ).animate()
          .fadeIn(duration: 500.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        const SizedBox(height: 24),
        // Titre avec gradient
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: _primaryGradient,
          ).createShader(bounds),
          child: Text(
            'Créer un compte',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
        const SizedBox(height: 12),
        // Sous-titre
        Text(
          'Rejoignez ChooseMe et connectez-vous\navec le monde du sport africain',
          textAlign: TextAlign.center,
          style: GoogleFonts.readexPro(
            fontSize: 15,
            color: theme.secondaryText,
            height: 1.5,
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 500.ms),
      ],
    );
  }

  Widget _buildFormSection(FlutterFlowTheme theme) {
    return Form(
      key: _model.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.secondaryBackground.withOpacity(0.7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.alternate.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Informations personnelles', Icons.person_outline, theme),
            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _model.nomTextController!,
              focusNode: _model.nomFocusNode!,
              label: 'Nom complet',
              hint: 'Entrez votre nom complet',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.name,
              theme: theme,
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
            const SizedBox(height: 16),
            _buildModernTextField(
              controller: _model.mailTextController!,
              focusNode: _model.mailFocusNode!,
              label: 'Adresse e-mail',
              hint: 'exemple@email.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              theme: theme,
            ).animate(delay: 450.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
            const SizedBox(height: 16),
            _buildPhoneField(theme).animate(delay: 500.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
            const SizedBox(height: 24),
            _buildSectionTitle('Sécurité', Icons.lock_outline, theme),
            const SizedBox(height: 20),
            _buildPasswordField(
              controller: _model.codeTextController!,
              focusNode: _model.codeFocusNode!,
              label: 'Mot de passe',
              hint: 'Créez un mot de passe sécurisé',
              isVisible: _model.codeVisibility,
              onToggle: () => safeSetState(() => _model.codeVisibility = !_model.codeVisibility),
              theme: theme,
            ).animate(delay: 550.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _model.confirmeTextController!,
              focusNode: _model.confirmeFocusNode!,
              label: 'Confirmer le mot de passe',
              hint: 'Confirmez votre mot de passe',
              isVisible: _model.confirmeVisibility,
              onToggle: () => safeSetState(() => _model.confirmeVisibility = !_model.confirmeVisibility),
              theme: theme,
            ).animate(delay: 600.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
            const SizedBox(height: 24),
            _buildSectionTitle('Type de profil', Icons.category_outlined, theme),
            const SizedBox(height: 16),
            _buildProfileTypeSelector(theme).animate(delay: 650.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            _buildSectionTitle('Localisation', Icons.location_on_outlined, theme),
            const SizedBox(height: 16),
            _buildCountrySelector(theme).animate(delay: 700.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            _buildTermsCheckbox(theme).animate(delay: 750.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            _buildSubmitButton(theme).animate(delay: 800.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ).animate(delay: 350.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, FlutterFlowTheme theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _primaryGradient[0].withOpacity(0.15),
                _primaryGradient[1].withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryGradient[0], size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required FlutterFlowTheme theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        style: GoogleFonts.readexPro(
          fontSize: 15,
          color: theme.primaryText,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.readexPro(
            color: theme.secondaryText,
            fontSize: 14,
          ),
          hintStyle: GoogleFonts.readexPro(
            color: theme.secondaryText.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryGradient[0].withOpacity(0.1),
                  _primaryGradient[1].withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _primaryGradient[0], size: 20),
          ),
          filled: true,
          fillColor: theme.primaryBackground,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.alternate.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _primaryGradient[0], width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.error, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.error, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
    required FlutterFlowTheme theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: !isVisible,
        style: GoogleFonts.readexPro(
          fontSize: 15,
          color: theme.primaryText,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.readexPro(
            color: theme.secondaryText,
            fontSize: 14,
          ),
          hintStyle: GoogleFonts.readexPro(
            color: theme.secondaryText.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryGradient[0].withOpacity(0.1),
                  _primaryGradient[1].withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.lock_outline, color: _primaryGradient[0], size: 20),
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: theme.secondaryText,
              size: 22,
            ),
          ),
          filled: true,
          fillColor: theme.primaryBackground,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.alternate.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _primaryGradient[0], width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.error, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.error, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPhoneField(FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryGradient[0].withOpacity(0.1),
                  _primaryGradient[1].withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.phone_outlined, color: _primaryGradient[0], size: 20),
          ),
          SizedBox(
            width: 110,
            child: FlutterFlowDropDown<String>(
              controller: _model.codepaysValueController ??= FormFieldController<String>(null),
              options: const [
                '+243 (RDC)',
                '+225 (CI)',
                '+237 (CMR)',
                '+254 (KEN)',
                '+234 (NGA)',
                '+221 (SEN)',
                '+233 (GHA)',
                '+27 (ZAF)',
                '+212 (MAR)',
                '+216 (TUN)',
                '+20 (EGY)',
              ],
              onChanged: (val) => safeSetState(() => _model.codepaysValue = val),
              width: 110,
              height: 50,
              textStyle: GoogleFonts.readexPro(
                fontSize: 13,
                color: theme.primaryText,
              ),
              hintText: 'Code',
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.secondaryText,
                size: 20,
              ),
              fillColor: Colors.transparent,
              elevation: 0,
              borderColor: Colors.transparent,
              borderWidth: 0,
              borderRadius: 8,
              margin: EdgeInsets.zero,
              hidesUnderline: true,
              isOverButton: false,
              isSearchable: false,
              isMultiSelect: false,
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: theme.alternate.withOpacity(0.5),
          ),
          Expanded(
            child: TextFormField(
              controller: _model.telTextController,
              focusNode: _model.telFocusNode,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.readexPro(
                fontSize: 15,
                color: theme.primaryText,
              ),
              decoration: InputDecoration(
                hintText: 'Numéro de téléphone',
                hintStyle: GoogleFonts.readexPro(
                  color: theme.secondaryText.withOpacity(0.6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTypeSelector(FlutterFlowTheme theme) {
    return FlutterFlowChoiceChips(
      options: [
        ChipData(
          valueOrDefault<String>(FFAppState().joueur, 'joueur'),
          Icons.sports_soccer_rounded,
        ),
        ChipData(
          valueOrDefault<String>(FFAppState().recruteur, 'recruteur'),
          Icons.manage_accounts_rounded,
        ),
        ChipData(
          valueOrDefault<String>(FFAppState().equipe, 'equipe'),
          Icons.groups_rounded,
        ),
        ChipData(
          valueOrDefault<String>(FFAppState().journaliste, 'journaliste'),
          FontAwesomeIcons.userTie,
        ),
        ChipData(
          valueOrDefault<String>(FFAppState().visiteur, 'visiteur'),
          Icons.person_outline_rounded,
        ),
      ],
      onChanged: (val) => safeSetState(() => _model.choiceChipsValue = val?.firstOrNull),
      selectedChipStyle: ChipStyle(
        backgroundColor: _primaryGradient[0],
        textStyle: GoogleFonts.readexPro(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        iconColor: Colors.white,
        iconSize: 18,
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
      ),
      unselectedChipStyle: ChipStyle(
        backgroundColor: theme.primaryBackground,
        textStyle: GoogleFonts.readexPro(
          color: theme.secondaryText,
          fontSize: 13,
        ),
        iconColor: theme.secondaryText,
        iconSize: 18,
        elevation: 0,
        borderColor: theme.alternate.withOpacity(0.5),
        borderWidth: 1,
        borderRadius: BorderRadius.circular(12),
      ),
      chipSpacing: 10,
      rowSpacing: 10,
      multiselect: false,
      alignment: WrapAlignment.start,
      controller: _model.choiceChipsValueController ??= FormFieldController<List<String>>([]),
      wrapped: true,
    );
  }

  Widget _buildCountrySelector(FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FlutterFlowDropDown<String>(
        controller: _model.paysValueController ??= FormFieldController<String>(null),
        options: const [
          'République démocratique du Congo',
          'Côte d\'Ivoire',
          'Cameroun',
          'Sénégal',
          'Mali',
          'Burkina Faso',
          'Guinée',
          'Niger',
          'Bénin',
          'Togo',
          'Ghana',
          'Nigeria',
          'Kenya',
          'Tanzanie',
          'Ouganda',
          'Rwanda',
          'Burundi',
          'Afrique du Sud',
          'Maroc',
          'Algérie',
          'Tunisie',
          'Égypte',
          'Éthiopie',
          'Angola',
          'Mozambique',
          'Zimbabwe',
          'Zambie',
          'Malawi',
          'Madagascar',
          'Gabon',
          'Congo',
          'République centrafricaine',
          'Tchad',
          'Mauritanie',
          'Libéria',
          'Sierra Leone',
          'Gambie',
          'Guinée-Bissau',
          'Cap-Vert',
          'São Tomé-et-Príncipe',
          'Guinée équatoriale',
          'Comores',
          'Maurice',
          'Seychelles',
          'Djibouti',
          'Érythrée',
          'Somalie',
          'Soudan',
          'Soudan du Sud',
          'Libye',
          'Botswana',
          'Namibie',
          'Eswatini',
          'Lesotho',
        ],
        onChanged: (val) => safeSetState(() => _model.paysValue = val),
        width: double.infinity,
        height: 58,
        searchHintTextStyle: GoogleFonts.readexPro(
          color: theme.secondaryText,
          fontSize: 14,
        ),
        searchTextStyle: GoogleFonts.readexPro(
          color: theme.primaryText,
          fontSize: 14,
        ),
        textStyle: GoogleFonts.readexPro(
          color: theme.primaryText,
          fontSize: 15,
        ),
        hintText: 'Sélectionnez votre pays',
        searchHintText: 'Rechercher un pays...',
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.secondaryText,
          size: 24,
        ),
        fillColor: theme.primaryBackground,
        elevation: 2,
        borderColor: theme.alternate.withOpacity(0.5),
        borderWidth: 1,
        borderRadius: 16,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        hidesUnderline: true,
        isOverButton: false,
        isSearchable: true,
        isMultiSelect: false,
      ),
    );
  }

  Widget _buildTermsCheckbox(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
              value: _model.checkboxValue ?? false,
              onChanged: (newValue) => safeSetState(() => _model.checkboxValue = newValue!),
              activeColor: _primaryGradient[0],
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              side: BorderSide(color: theme.secondaryText, width: 1.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => context.pushNamed(PolitiqueWidget.routeName),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.readexPro(
                    fontSize: 13,
                    color: theme.secondaryText,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'J\'accepte les '),
                    TextSpan(
                      text: 'conditions d\'utilisation',
                      style: TextStyle(
                        color: _primaryGradient[0],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: TextStyle(
                        color: _primaryGradient[0],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _primaryGradient),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryGradient[0].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: _handleCreateAccount,
        text: 'Créer mon compte',
        icon: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 22),
        options: FFButtonOptions(
          width: double.infinity,
          height: 58,
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          textStyle: GoogleFonts.readexPro(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildFooterSection(FlutterFlowTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Vous avez déjà un compte?',
          style: GoogleFonts.readexPro(
            color: theme.secondaryText,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () => context.pushNamed(ConnexionWidget.routeName),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: _primaryGradient,
            ).createShader(bounds),
            child: Text(
              'Se connecter',
              style: GoogleFonts.readexPro(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ).animate(delay: 850.ms).fadeIn(duration: 400.ms);
  }

  Future<void> _handleCreateAccount() async {
    GoRouter.of(context).prepareAuthEvent();
    
    if (_model.codeTextController.text != _model.confirmeTextController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Les mots de passe ne correspondent pas',
                style: GoogleFonts.readexPro(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final user = await authManager.createAccountWithEmail(
      context,
      _model.mailTextController.text,
      _model.codeTextController.text,
    );
    if (user == null) return;

    // Déterminer le statut et l'état en fonction du type de profil
    final String selectedType = _model.choiceChipsValue ?? '';
    final bool isVisiteur = selectedType == 'visiteur' || 
                           selectedType == FFAppState().visiteur;
    
    // Les visiteurs ont directement accès (statut ok, etat ac)
    // Les autres types doivent compléter leur profil (statut no, etat nv)
    await UserRecord.collection.doc(user.uid).update(createUserRecordData(
      email: _model.mailTextController.text,
      displayName: _model.nomTextController.text,
      phoneNumber: _model.telTextController.text,
      statut: isVisiteur ? 'ok' : 'no',
      pays: _model.paysValue,
      type: selectedType,
      codepays: _model.codepaysValue,
      etat: isVisiteur ? 'ac' : 'nv',
    ));

    // Redirection basée sur le type de profil sélectionné
    if (isVisiteur) {
      // Les visiteurs vont directement au tableau de bord
      context.pushNamedAuth(Home8Widget.routeName, context.mounted);
    } else if (selectedType == 'joueur' || selectedType == FFAppState().joueur) {
      context.pushNamedAuth(CompleteinfosjouereWidget.routeName, context.mounted);
    } else if (selectedType == 'equipe' || selectedType == FFAppState().equipe) {
      context.pushNamedAuth(ClubcreationprofilWidget.routeName, context.mounted);
    } else if (selectedType == 'journaliste' || selectedType == FFAppState().journaliste) {
      context.pushNamedAuth(PressecreatWidget.routeName, context.mounted);
    } else if (selectedType == 'recruteur' || selectedType == FFAppState().recruteur) {
      context.pushNamedAuth(RecruteurinfosWidget.routeName, context.mounted);
    } else {
      // Type non reconnu - page d'erreur
      context.pushNamedAuth(ErreurprofilWidget.routeName, context.mounted);
    }
  }
}
