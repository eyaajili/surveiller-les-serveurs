import 'package:flutter/material.dart';
import'package:flutter_native_splash/flutter_native_splash.dart';
import 'addUser.dart';
import 'login.dart';
import 'tachesAdmin.dart';
import'EntryPoint.dart';
import'EntryPoint2.dart';
import'utilisateurs.dart';
import'maintenance.dart';
import'notifications.dart';
import'Historique.dart';
import'notificationsAdmin.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Préserve le splash screen...");
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  print("Attendre 2 secondes...");
  await Future.delayed(const Duration(seconds: 2));

  print("Supprime le splash screen...");
  FlutterNativeSplash.remove();

  print("Initialisation de Firebase...");
  await Firebase.initializeApp();
  print("Firebase initialisé avec succès.");

  runApp(MyApp());
}

// Dans MyApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => loginpage(),
        '/add': (context) => addUser(),
        '/historique': (context) => historique(),
        '/tachesAdmin': (context) => tachesAdmin(),
        '/utilisateurs': (context) => utilisateurs(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/maintenance') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => maintenance(
              numeroSalle: args['numeroSalle'],
              nomDepartement: args['nomDepartement'],
              nomUtilisateur: args['nomUtilisateur'],
              idSalle: args['idSalle'],
            ),
          );
        }
        else if (settings.name == '/notificationsAdmin') {
          final args = settings.arguments as Map<String, dynamic>;
          final nom = args['nom'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) => notificationsAdmin(
              name: nom,
            ),
          );
        } else if (settings.name == '/notifications') {
          final args = settings.arguments as Map<String, dynamic>;
          final nom = args['nom'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) => notifications(
              name: nom,

            ),
          );
        }
 else if (settings.name == '/entrypoint') {
          final args = settings.arguments as Map<String, dynamic>;
          final nom = args['nom'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) => EntryPoint(
              name: nom,
             role:role,
            ),
          );
        }else if (settings.name == '/entrypoint2') {
          final args = settings.arguments as Map<String, dynamic>;
          final nom = args['nom'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) => EntryPoint2(
              name: nom,
             role:role,
            ),
          );
        }

      },
      debugShowCheckedModeBanner: false,
      home: loginpage(),
    );
  }
}
