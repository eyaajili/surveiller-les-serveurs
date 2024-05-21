import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {
        required this.artboard,
        required this.stateMachineName,
        required this.title,
        this.input
      });

  set setInput(SMIBool status) {
    input = status;
  }
}



List<RiveAsset> sideMenus = [
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "HOME",
    stateMachineName: "HOME_interactivity",
    title: "Acceuil",
  ),
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "SIGNOUT",
    stateMachineName: "SIGNOUT_Interactvity",
    title: "Liste des utilisateurs",
  ),
];
List<RiveAsset> sideMenu2 = [
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "TIMER",
    stateMachineName: "TIMER_Interactivity",
    title: "Historique",
  ),
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "BELL",
    stateMachineName: "BELL_Interactivity",
    title: "Consulter Notifications",
  ),
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "RULES",
    stateMachineName: "TACHES_Interactivity",
    title: "Gérer les taches",
  ),];
List<RiveAsset> sideMenu1 = [
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "EXIT",
    stateMachineName: "EXIT_Interactivity",
    title: "Déconnecter",
  ),];
List<RiveAsset> sideMenu4 = [
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "EXIT",
    stateMachineName: "EXIT_Interactivity",
    title: "Déconnexion",
  ),];
List<RiveAsset> sideMenu3 = [
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "BELL",
    stateMachineName: "BELL_Interactivity",
    title: "Notifications",
  ),
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "LOADING",
    stateMachineName: "WORK_Interactivity",
    title: "Surveiller les serveurs",
  ),
  RiveAsset(
    "RiveAssets/icons.riv",
    artboard: "RULES",
    stateMachineName: "TACHES_Interactivity",
    title: "Taches",
  ),
];