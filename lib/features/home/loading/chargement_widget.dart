import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_theme.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'chargement_model.dart';
export 'chargement_model.dart';

/// cree menant une page de chargement avec un logo
class ChargementWidget extends StatefulWidget {
  const ChargementWidget({super.key});

  static String routeName = 'chargement';
  static String routePath = 'chargement';

  @override
  State<ChargementWidget> createState() => _ChargementWidgetState();
}

class _ChargementWidgetState extends State<ChargementWidget> {
  late ChargementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChargementModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        const Duration(
          milliseconds: 5000,
        ),
      );
      
      final String statut = valueOrDefault(currentUserDocument?.statut, '');
      final String etat = valueOrDefault(currentUserDocument?.etat, '');
      final String type = valueOrDefault(currentUserDocument?.type, '');
      
      // Cas 1: Nouveau compte qui doit compléter son profil
      if (statut == 'no' && etat == 'nv') {
        if (type == 'joueur') {
          context.pushNamed(CompleteinfosjouereWidget.routeName);
        } else if (type == 'recruteur') {
          context.pushNamed(RecruteurinfosWidget.routeName);
        } else if (type == 'equipe') {
          context.pushNamed(ClubcreationprofilWidget.routeName);
        } else if (type == 'journaliste') {
          context.pushNamed(PressecreatWidget.routeName);
        } else if (type == 'visiteur') {
          // Visiteur nouveau - accès direct au feed
          context.pushNamed(Home8Widget.routeName);
        } else {
          // Type non reconnu
          context.pushNamed(ErreurprofilWidget.routeName);
        }
      } 
      // Cas 2: Compte en attente de validation
      else if (statut == 'no' && etat == 'ac') {
        context.pushNamed(StatutcompteWidget.routeName);
      } 
      // Cas 3: Compte validé et actif
      else if (statut == 'ok' && etat == 'ac') {
        if (type == 'joueur') {
          context.pushNamed(AfficheTalentprofilWidget.routeName);
        } else if (type == 'recruteur') {
          context.pushNamed(TbdmanagereWidget.routeName);
        } else if (type == 'journaliste') {
          context.pushNamed(TbdpresseWidget.routeName);
        } else if (type == 'equipe') {
          context.pushNamed(TbclubWidget.routeName);
        } else if (type == 'adm') {
          context.pushNamed(TBDgeneralADMWidget.routeName);
        } else if (type == 'visiteur') {
          context.pushNamed(Home8Widget.routeName);
        } else {
          // Type non reconnu
          context.pushNamed(ErreurprofilWidget.routeName);
        }
      } 
      // Cas 4: Admin (autre format de statut)
      else if (statut == 'ac' && etat == 'ok' && type == 'adm') {
        context.pushNamed(TBDgeneralADMWidget.routeName);
      }
      // Cas par défaut: page d'erreur
      else {
        context.pushNamed(ErreurprofilWidget.routeName);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/Untitled.gif',
                    ).image,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
