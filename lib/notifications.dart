import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String date;
  final String objet;
  final String technicien;
  final String commentaire;

  NotificationModel({
    required this.date,
    required this.objet,
    required this.technicien,
    required this.commentaire,
  });
}

class notifications extends StatefulWidget {
  final String name;

  notifications({required this.name});

  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _objetController = TextEditingController();
  TextEditingController _commentaireController = TextEditingController();

  @override
  void dispose() {
    _objetController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Notification').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          String _formatDate(DateTime date) {
            String formattedDate =
                '${date.day.toString().padLeft(2, '0')}/${_getMonthName(date.month)}/${date.year}';
            return formattedDate;
          }

          final List<NotificationModel> notifications = snapshot.data!.docs.map((DocumentSnapshot document) {
            if (document.exists) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return NotificationModel(
                date: _formatDate((data['Date'] as Timestamp).toDate()),
                objet: data['objet'],
                technicien: data['nom'],
                commentaire: data['commentaire'],
              );
            } else {
              return NotificationModel(date: '', objet: '', technicien: '', commentaire: '');
            }
          }).toList();

          return notifications.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Image.asset("Images/no notification.png", width: 250),
                SizedBox(height: 50),
                Text(
                  "Pas de notifications pour le moment !",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          )
              : Column(
            children: [
              SizedBox(height: 75),
              Row(
                children: [
                  SizedBox(width: 40),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent.shade100,
                    ),
                  ),
                  SizedBox(width: 30),
                  Image.asset('Images/bell2.png', width: 100),
                ],
              ),
              SizedBox(height: 35),
              Expanded(
                child: Container(
                  width: 390,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.blue.shade50,
                                  title: Text(
                                    'Commentaire',
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    notifications[index].commentaire,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            color: Colors.blueAccent.shade100,
                            elevation: 20,
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                'Images/bell3.png',
                                width: 70,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        '${notifications[index].date}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        '${notifications[index].objet}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.perm_identity_rounded,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        '${notifications[index].technicien}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade50,
        onPressed: () {
          showDialog(
            useSafeArea: true,
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.blue.shade50,
                content: Container(
                  width: 200,
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ajouter notification',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _objetController,
                          decoration: InputDecoration(
                            labelText: 'Objet',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir le champ Objet.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _commentaireController,
                          decoration: InputDecoration(
                            labelText: 'Commentaire',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir le champ Commentaire.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseFirestore.instance.collection('Notification').add({
                                'Date': Timestamp.now(),
                                'objet': _objetController.text,
                                'nom': widget.name,
                                'commentaire': _commentaireController.text,
                              });

                              _objetController.clear();
                              _commentaireController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: Image.asset("Images/valider.png", width: 40),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}/${_getMonthName(dateTime.month)}/${dateTime.year}';
    return formattedDate;
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Janvier';
      case 2:
        return 'Février';
      case 3:
        return 'Mars';
      case 4:
        return 'Avril';
      case 5:
        return 'Mai';
      case 6:
        return 'Juin';
      case 7:
        return 'Juillet';
      case 8:
        return 'Août';
      case 9:
        return 'Septembre';
      case 10:
        return 'Octobre';
      case 11:
        return 'Novembre';
      case 12:
        return 'Décembre';
      default:
        return '';
    }
  }
}
