import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'rive_asset.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SideMenuTile extends StatefulWidget {
  const SideMenuTile({
    Key? key,
    required this.menu,
    required this.press,
    required this.riveonInit,
    required this.isActive,
    required this.nom,
    required this.role,
  }) : super(key: key);

  final RiveAsset menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveonInit;
  final bool isActive;
  final String nom;
  final String role;

  @override
  _SideMenuTileState createState() => _SideMenuTileState();
}

class _SideMenuTileState extends State<SideMenuTile> {
  String result = '';

  Future<void> scan(BuildContext context) async {
    bool scanCompleted = false;
    try {
      final code = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Annuler',
        true,
        ScanMode.QR,
      );
      if (code != '-1') {
        print('TEST DE , ${widget.nom}');

        QuerySnapshot departementsSnapshot = await FirebaseFirestore.instance
            .collection('Departements')
            .get();

        // Parcourir tous les documents de la collection "Departements"
        for (QueryDocumentSnapshot departementDoc in departementsSnapshot.docs) {
          // Recherche du code dans la sous-collection actuelle
          QuerySnapshot sallesSnapshot = await FirebaseFirestore.instance
              .collection('Departements')
              .doc(departementDoc.id)
              .collection('SallesServeurs')
              .where('id_salle', isEqualTo: code)
              .get();

          if (sallesSnapshot.docs.isNotEmpty) {
            String numeroSalle = sallesSnapshot.docs.first['numéro_salle'];
            String nomDepartement = departementDoc['nom'];
            String idSalle = code;
            Navigator.pushNamed(
              context,
              '/maintenance',
              arguments: {
                'numeroSalle': numeroSalle,
                'nomDepartement': nomDepartement,
                'nomUtilisateur': widget.nom,
                'idSalle': code,
              },
            );
            return;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Aucune salle serveur trouvée pour ce code QR.'),
        ));
      }
      setState(() {
        this.result = code.toString();
        scanCompleted = true;
      });
    } on PlatformException {
      if (!scanCompleted) {
        Navigator.pop(context);
      }

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('CodeQr invalide.'),
        ));
        scanCompleted = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.white24,
            height: 1,
          ),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              height: 56,
              width: widget.isActive ? 288 : 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isActive ? const Color(0xFF6792FF) : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                widget.press();
             Future.delayed(const Duration(milliseconds: 700), ()

   {
    if (widget.menu.title == "Acceuil") {Navigator.pushNamed(context, '/entrypoint',arguments: {'nom': widget.nom,'role': widget.role});}

    else if (widget.menu.title == "Liste des utilisateurs") {Navigator.pushNamed(context, '/utilisateurs');}

    else if (widget.menu.title == "Historique") {Navigator.pushNamed(context, '/historique');}

    else if (widget.menu.title == "Consulter Notifications") {Navigator.pushNamed(context, '/notificationsAdmin', arguments: {'nom': widget.nom});}

    else if (widget.menu.title == "Gérer les taches") {Navigator.pushNamed(context, '/tachesAdmin');}

    else if (widget.menu.title == "Déconnecter" || widget.menu.title == "Déconnexion") {Navigator.pushNamed(context, '/login');}

    else if (widget.menu.title == "Notifications") {Navigator.pushNamed(context, '/notifications', arguments: {'nom': widget.nom});}

    else if (widget.menu.title == "Taches") {Navigator.pushNamed(context, '/entrypoint2',arguments: {'nom': widget.nom,'role': widget.role});}


    else if (widget.menu.title == "Surveiller les serveurs") {
    scan(context);
    }}
                );
                },

    leading: SizedBox(
                height: 34,
                width: 34,
                child: RiveAnimation.asset(
                  widget.menu.src,
                  artboard: widget.menu.artboard,
                  onInit: widget.riveonInit,
                ),
              ),
              title: Text(
                widget.menu.title,
                style: TextStyle(
                  color: widget.isActive ? const Color(0xFF6792FF) : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
