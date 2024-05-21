import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:Maintenance/HistoriqueDetails.dart';

class historique extends StatefulWidget {
  @override
  _historiqueState createState() => _historiqueState();
}

class _historiqueState extends State<historique> {
  String? selectedDepartment;
  List<Map<String, dynamic>>? departmentVisits = [];
  List<String> departments = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments().then((fetchedDepartments) {
      setState(() {
        departments = fetchedDepartments;
      });
    });
  }

  Future<void> fetchVisits() async {
    try {
      if (selectedDepartment != null) {
        List<Map<String, dynamic>> visits = [];

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Visite')
            .where('nom_departement', isEqualTo: selectedDepartment)
            .get();

        querySnapshot.docs.forEach((doc) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(doc['Date'].seconds * 1000);
          String formattedDate = DateFormat('dd/MM/yyyy').format(date);

          visits.add({
            'id': doc.id,
            'date': formattedDate,
            'roomNumber': doc['numéro_salle'],
            'technician': doc['nom'],
            'timestamp': date, // Store the original date for sorting
          });
        });

        // Sort visits by date in descending order
        visits.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        setState(() {
          departmentVisits = visits;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des visites : $e');
    }
  }

  Future<List<String>> fetchDepartments() async {
    List<String> departments = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Departements').get();
      for (var doc in querySnapshot.docs) {
        departments.add(doc['nom']); // Ensure the 'nom' field exists in your department documents
      }
    } catch (e) {
      print('Erreur lors de la récupération des départements : $e');
    }
    return departments;
  }

  void handleDepartmentChange(String? department) {
    setState(() {
      selectedDepartment = department;
    });
    fetchVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30), // Add some space between the top of the interface and the "Historique" text
            Row(
              children: [
                SizedBox(width: 40),
                Text(
                  'Historique',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(width: 70),
                Image.asset('Images/historique.png', width: 100), // Main icon
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Choisissez département:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 17),
                DropdownButton<String>(
                  value: selectedDepartment,
                  onChanged: handleDepartmentChange,
                  items: departments.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.blue.shade900)),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (selectedDepartment != null && departmentVisits != null)
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
                      itemCount: departmentVisits!.length,
                      itemBuilder: (context, index) {
                        var visit = departmentVisits![index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoriqueDetails(visitId: visit['id']),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.blueAccent.shade100,
                            elevation: 24,
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              leading: Image.asset('Images/historiqueIcon.png', width: 40, color: Colors.white), // Main icon
                              title: Row(
                                children: [
                                  Icon(Icons.date_range_outlined, color: Colors.white, size: 20), // Date icon
                                  SizedBox(width: 10),
                                  Text(
                                    'Date: ${visit['date']}',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Icon(Icons.meeting_room_outlined, color: Colors.white, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        'Numéro Salle: ${visit['roomNumber']}',
                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Icon(Icons.person_outlined, color: Colors.white, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        'Technicien: ${visit['technician']}',
                                        style: TextStyle(fontSize: 16, color: Colors.white),
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
        ),
      ),
    );
  }
}
