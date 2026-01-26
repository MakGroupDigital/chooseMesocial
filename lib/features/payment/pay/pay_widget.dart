import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'pay_model.dart';
export 'pay_model.dart';

class PayWidget extends StatefulWidget {
  const PayWidget({super.key});

  static String routeName = 'pay';
  static String routePath = 'pay';

  @override
  State<PayWidget> createState() => _PayWidgetState();
}

class _PayWidgetState extends State<PayWidget> {
  late PayModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedMethod = 'card';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PayModel());
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
                      shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]).createShader(bounds),
                      child: Text('Paiement', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order summary
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [const Color(0xFF208050).withOpacity(0.2), const Color(0xFF19DB8A).withOpacity(0.1)]),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF19DB8A).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.star, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Abonnement Premium', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                                  Text('Accès illimité pendant 1 an', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                                ],
                              ),
                            ),
                            Text('\$50', style: GoogleFonts.inter(color: const Color(0xFF19DB8A), fontWeight: FontWeight.bold, fontSize: 24)),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                      const SizedBox(height: 32),

                      Text('Méthode de paiement', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                      const SizedBox(height: 16),

                      // Payment methods
                      _buildPaymentMethod('card', 'Carte bancaire', Icons.credit_card, Colors.blue),
                      _buildPaymentMethod('mobile', 'Mobile Money', Icons.phone_android, Colors.orange),
                      _buildPaymentMethod('paypal', 'PayPal', Icons.account_balance_wallet, Colors.indigo),

                      const SizedBox(height: 32),

                      // Pay button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF208050), Color(0xFF19DB8A)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: const Color(0xFF19DB8A).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: FFButtonWidget(
                          onPressed: () => context.pushNamed(OkWidget.routeName),
                          text: 'Payer \$50',
                          icon: const Icon(Icons.lock, color: Colors.white, size: 20),
                          options: FFButtonOptions(
                            height: 56,
                            color: Colors.transparent,
                            textStyle: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                            elevation: 0,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock, color: Colors.white.withOpacity(0.5), size: 14),
                            const SizedBox(width: 8),
                            Text('Paiement sécurisé SSL', style: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                          ],
                        ),
                      ),
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

  Widget _buildPaymentMethod(String id, String label, IconData icon, Color color) {
    final isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.white.withOpacity(0.1), width: isSelected ? 2 : 1),
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
            Expanded(child: Text(label, style: GoogleFonts.readexPro(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16))),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? color : Colors.white.withOpacity(0.3), width: 2),
                color: isSelected ? color : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
