import 'package:flutter/material.dart';
import 'package:Maintenance/controllers/Liste_controller.dart';
import 'package:Maintenance/models/Liste_model.dart';
import 'package:Maintenance/controllers/delete_controller.dart';

class utilisateurs extends StatefulWidget {
  @override
  _utilisateursState createState() => _utilisateursState();
}

class _utilisateursState extends State<utilisateurs> {
  final ListeController _listController = ListeController();
  final DeleteController _deleteController = DeleteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 55),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  'Gérer les comptes',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Image.asset('Images/users.png', width: 100),
              ],
            ),
            SizedBox(height: 10),
            Expanded(child:Container(
              width: 390,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(330, 10, 10, 10),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add');
                      },
                      child: Icon(Icons.add, color: Colors.black87),
                      backgroundColor: Colors.blue.shade50,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<ListeModel>>(
                      future: _listController.getUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        List<ListeModel> users = snapshot.data ?? [];
                        if (users.isEmpty) {
                          return Center(child: Text('Aucun utilisateur trouvé.'));
                        }
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Dismissible(
                              key: Key(user.nom),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmation"),
                                      content: Text("Êtes-vous sûr de vouloir supprimer cet utilisateur ?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            bool result = await _deleteController.deleteUserByMatricule(user.matricule);
                                            if (result) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Utilisateur supprimé avec succès.'),
                                              ));
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Erreur lors de la suppression de l\'utilisateur.'),
                                              ));
                                            }
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text('Confirmer'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                setState(() {
                                  users.removeAt(index);
                                });
                              },
                              child: ListTile(
                                leading: user.role.toLowerCase().contains('admin')
                                    ? Image.asset('Images/admin.png', width: 40, height: 40, color: Colors.black87)
                                    : Image.asset('Images/technicien.png', width: 40, height: 40, color: Colors.black87),
                                title: Text(user.nom, style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                                subtitle: Text(user.matricule, style: TextStyle(fontSize: 12, color: Colors.black54)),
                                trailing: Text(user.role, style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                                onTap: () {
                                  print('User tapped: ${user.nom}');
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
