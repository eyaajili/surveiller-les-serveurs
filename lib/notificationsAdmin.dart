import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final DateTime date;
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

class notificationsAdmin extends StatefulWidget {
  final String name;
  notificationsAdmin({required this.name});

  @override
  _notificationsAdminState createState() => _notificationsAdminState();
}

class _notificationsAdminState extends State<notificationsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notification')
            .orderBy('Date', descending: true) // Order by date in descending order
            .snapshots(),
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

          final List<NotificationModel> notifications = snapshot.data!.docs.map((DocumentSnapshot document) {
            if (document.exists) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return NotificationModel(
                date: (data['Date'] as Timestamp).toDate(),
                objet: data['objet'],
                technicien: data['nom'],
                commentaire: data['commentaire'],
              );
            } else {
              return NotificationModel(date: DateTime.now(), objet: '', technicien: '', commentaire: '');
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
                )
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
                        return Dismissible(
                          key: Key(notifications[index].objet),
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
                                  content: Text("Êtes-vous sûr de vouloir supprimer cette notification ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Notification')
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          backgroundColor: Colors.blue.shade50,
                                          content: Text('Notification supprimée avec succès', style: TextStyle(color: Colors.black, fontSize: 20)),
                                        ));
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
                              notifications.removeAt(index);
                            });
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
                                        _formatDate(notifications[index].date),
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
                                        notifications[index].objet,
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
                                        notifications[index].technicien,
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
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')} / ${_getMonthName(dateTime.month)} / ${dateTime.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Janvier';
      case 2:
        return 'février';
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
