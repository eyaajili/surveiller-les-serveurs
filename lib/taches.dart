import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final Timestamp date;
  final String salle;
  final String department;

  Task({
    required this.date,
    required this.salle,
    required this.department,
  });
}

class taches extends StatelessWidget {
  final String name;

  taches({required this.name});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      key: UniqueKey(), // Add a key to the StreamBuilder
      stream: FirebaseFirestore.instance
          .collection('Taches')
          .where('nom', isEqualTo: name)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<Task> tasks = snapshot.data!.docs.map((doc) {
          return Task(
            date: doc['Date'],
            salle: doc['numéro_salle'],
            department: doc['nom_departement'],
          );
        }).toList();

        // Filter tasks based on the current date (year, month, and day)
        DateTime currentDate = DateTime.now();
        tasks = tasks.where((task) {
          DateTime taskDate = task.date.toDate();
          return taskDate.year == currentDate.year &&
              taskDate.month == currentDate.month &&
              taskDate.day == currentDate.day;
        }).toList();

        if (tasks.isEmpty) {
          return _buildNoTasksWidget();
        } else {
          return _buildTasksList(context, tasks, snapshot.data!.docs);
        }
      },
    );
  }

  Widget _buildNoTasksWidget() {
    return Container(
      color: Colors.grey.shade200, // Set background color to grey
      child: Center(
        child: Column(
          children: [
            SizedBox(height:200),

            Image.asset('Images/no-task.png', width:250),
            SizedBox(height: 40),
            Text(
              'Pas de tâche pour le moment',
              style: TextStyle(
                color:Colors.blue.shade900,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(
      BuildContext context, List<Task> tasks, List<QueryDocumentSnapshot> docs) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      body: Column(
        children: [
          SizedBox(height: 75),
          Row(
            children: [
              SizedBox(width: 40),
              Text(
                'Vos Taches',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 70),
              Image.asset('Images/task.png', width: 100),
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
                    color: Colors.grey.withOpacity(1),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(context, tasks[index], docs[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, QueryDocumentSnapshot doc) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                      color: Colors.black87,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _formatDate(task.date),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.meeting_room_outlined,
                      color: Colors.black87,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'salle N°${task.salle}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      color: Colors.black87,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Département :${task.department}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Image.asset('Images/check.png', width: 50),
              onPressed: () async {
                _showDeleteConfirmationDialog(context, doc);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, QueryDocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Colors.blue.shade50,
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette tâche?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('Taches')
                      .doc(doc.id)
                      .delete();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tâche supprimée avec succès',style:TextStyle(color: Colors.black,fontSize:20)),
                      backgroundColor: Colors.blue.shade50,
                    ),
                  );
                } catch (error) {
                  print('Error deleting task: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la suppression de la tâche',style:TextStyle(color: Colors.black,fontSize: 30)),
                      backgroundColor: Colors.blue.shade50,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
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
