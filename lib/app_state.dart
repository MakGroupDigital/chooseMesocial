import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _equipe = prefs.getString('ff_equipe') ?? _equipe;
    });
    _safeInit(() {
      _joueur = prefs.getString('ff_joueur') ?? _joueur;
    });
    _safeInit(() {
      _recruteur = prefs.getString('ff_recruteur') ?? _recruteur;
    });
    _safeInit(() {
      _journaliste = prefs.getString('ff_journaliste') ?? _journaliste;
    });
    _safeInit(() {
      _like = prefs.getBool('ff_like') ?? _like;
    });
    _safeInit(() {
      _isMuted = prefs.getBool('ff_isMuted') ?? _isMuted;
    });
    _safeInit(() {
      _whatsaap = prefs.getString('ff_whatsaap') ?? _whatsaap;
    });
    _safeInit(() {
      _imageurl = prefs.getString('ff_imageurl') ?? _imageurl;
    });
    _safeInit(() {
      _imagarticle = prefs.getString('ff_imagarticle') ?? _imagarticle;
    });
    _safeInit(() {
      _visiteur = prefs.getString('ff_visiteur') ?? _visiteur;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _equipe = '';
  String get equipe => _equipe;
  set equipe(String value) {
    _equipe = value;
    prefs.setString('ff_equipe', value);
  }

  String _joueur = '';
  String get joueur => _joueur;
  set joueur(String value) {
    _joueur = value;
    prefs.setString('ff_joueur', value);
  }

  String _recruteur = '';
  String get recruteur => _recruteur;
  set recruteur(String value) {
    _recruteur = value;
    prefs.setString('ff_recruteur', value);
  }

  String _journaliste = '';
  String get journaliste => _journaliste;
  set journaliste(String value) {
    _journaliste = value;
    prefs.setString('ff_journaliste', value);
  }

  bool _like = false;
  bool get like => _like;
  set like(bool value) {
    _like = value;
    prefs.setBool('ff_like', value);
  }

  bool _isMuted = true;
  bool get isMuted => _isMuted;
  set isMuted(bool value) {
    _isMuted = value;
    prefs.setBool('ff_isMuted', value);
  }

  String _whatsaap = '';
  String get whatsaap => _whatsaap;
  set whatsaap(String value) {
    _whatsaap = value;
    prefs.setString('ff_whatsaap', value);
  }

  String _imageurl = '';
  String get imageurl => _imageurl;
  set imageurl(String value) {
    _imageurl = value;
    prefs.setString('ff_imageurl', value);
  }

  String _imagarticle = '';
  String get imagarticle => _imagarticle;
  set imagarticle(String value) {
    _imagarticle = value;
    prefs.setString('ff_imagarticle', value);
  }

  String _visiteur = '';
  String get visiteur => _visiteur;
  set visiteur(String value) {
    _visiteur = value;
    prefs.setString('ff_visiteur', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
