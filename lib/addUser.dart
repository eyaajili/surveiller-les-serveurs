import 'package:flutter/material.dart';
import 'package:Maintenance/models/Adduser_model.dart';
import 'package:Maintenance/controllers/Adduser_controller.dart';

class addUser extends StatelessWidget {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController motdepasseController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final AddUserController _addUserController = AddUserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 320, top: 50),
                child: FloatingActionButton(
                  backgroundColor: Colors.grey.shade300,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset('Images/annuler.png', height: 20, width: 20),
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: 380,
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.blue.shade900.withOpacity(1),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'Images/addUser.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom Utilisateur',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: matriculeController,
                        decoration: InputDecoration(
                          labelText: 'Matricule',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: motdepasseController,
                        decoration: InputDecoration(
                          labelText: 'Mot de Passe',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: roleController,
                        decoration: InputDecoration(
                          labelText: 'Role',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FloatingActionButton(
                      backgroundColor: Colors.blueGrey.shade50,
                      onPressed: () {
                        _addUser(context);
                      },
                      child: Image.asset('Images/valider.png'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addUser(BuildContext context) {
    String nom = nomController.text;
    String matriculeText = matriculeController.text;
    String motdepasse = motdepasseController.text;
    String role = roleController.text;

    // Vérifier que la matricule est un nombre
    if (matriculeText.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La matricule doit avoir au moins 5 caractères.'),
      ));
      return;
    }

    // Vérifier que le nom contient uniquement des lettres
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(nom)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Le nom doit contenir uniquement des lettres.'),
      ));
      return;
    }

    // Vérifier que le mot de passe contient au moins 8 caractères
    if (motdepasse.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Le mot de passe doit contenir au moins 8 caractères.'),
      ));
      return;
    }
    // Vérifier que le rôle est soit "admin" soit "technicien"
    if (role != "admin" && role != "technicien" && role !="Technicien" && role !="Admin" && role !="TECHNICIEN" && role !="ADMIN") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Le rôle doit être "admin" ou "technicien".'),
      ));
      return;
    }

    // Si toutes les vérifications passent, continuer avec l'ajout de l'utilisateur
    AddUserModel user = AddUserModel(nom: nom, matricule: matriculeText, motdepasse: motdepasse, role: role);
    _addUserController.addUser(user);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Utilisateur ajouté avec succès'),
          content: Text('L\'utilisateur a été ajouté avec succès.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context,'/EntryPoint2');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

  }
}
