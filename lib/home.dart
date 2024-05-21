import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PieChart.dart';
import 'LineChart.dart';
import 'BarChart.dart';

class homepage extends StatefulWidget {
  @override
  homepageState createState() => homepageState();
}

class homepageState extends State<homepage> {
  List<String> departments = ['All'];
  Map<String, List<String>> roomNumbersMap = {'All': ['All']};
  String selectedDepartment = 'All';
  String selectedRoom = 'All';
  Map<String, int> statistics = {};

  @override
  void initState() {
    super.initState();
    fetchDepartments();
    calculateStatisticsForAll();
  }

  Future<void> fetchDepartments() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Departements').get();
      List<String> departmentNames =
      querySnapshot.docs.map((doc) => doc['nom'] as String).toList();
      setState(() {
        departments.addAll(departmentNames);
      });
      fetchRoomNumbers(selectedDepartment);
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> fetchRoomNumbers(String departmentName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Departements')
        .where('nom', isEqualTo: departmentName)
        .get();

    Map<String, List<String>> roomNumberMap = {'All': ['All']};
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot departmentDoc = querySnapshot.docs.first;
      QuerySnapshot roomNumbersSnapshot = await departmentDoc.reference
          .collection('SallesServeurs').get();
      List<String> roomNumberList = roomNumbersSnapshot.docs
          .map((doc) => doc['numéro_salle'].toString())
          .toList();
      roomNumberMap[departmentName] = ['All', ...roomNumberList];
    }

    setState(() {
      roomNumbersMap = roomNumberMap;
    });
  }
  Future<void> calculateStatistics() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Visite')
          .where('nom_departement', isEqualTo: selectedDepartment)
          .where('numéro_salle', isEqualTo: selectedRoom)
          .get();

      Map<String, int> stats = {};
      int totalVerifications = 0;

      querySnapshot.docs.forEach((doc) {
        List<dynamic> verifications = doc['Vérification'];
        for (var verification in verifications) {
          String type = verification['type'];
          if (verification['etat'] == 'nonok' && type != null) {
            stats[type] = (stats[type] ?? 0) + 1;
            totalVerifications++;
          }
        }
      });

      print('Department: $selectedDepartment, Room: $selectedRoom');
      print('Nonok Verifications: $totalVerifications');

      Map<String, int> percentageStats = {};
      stats.forEach((type, count) {
        percentageStats[type] = ((count / totalVerifications) * 100).round();
      });

      setState(() {
        statistics = percentageStats;
      });
    } catch (e) {
      print('Error calculating statistics: $e');
    }
  }


  Future<void> calculateStatisticsForAll() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Visite').get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          statistics = {};
        });
        return;
      }

      Map<String, int> stats = {};
      int totalVerifications = 0;

      querySnapshot.docs.forEach((doc) {
        List<dynamic> verifications = doc['Vérification'];
        for (var verification in verifications) {
          String type = verification['type'];
          if (verification['etat'] == 'nonok' && type != null) {
            stats[type] = (stats[type] ?? 0) + 1;
            totalVerifications++;
          }
        }
      });

      Map<String, int> percentageStats = {};
      stats.forEach((type, count) {
        percentageStats[type] = ((count / totalVerifications) * 100).round();
      });

      setState(() {
        statistics = percentageStats;
      });
    } catch (e) {
      print('Error calculating statistics for all: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 90, horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Tableau de bord Administratif',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  Image.asset('Images/team-work.png', width: 80),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [                  SizedBox(width:20),

                  Text(
                    'Département:',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width:20),
                  DropdownButton<String>(
                    value: selectedDepartment,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedDepartment = newValue;
                          if (newValue == 'All') {
                            selectedRoom = 'All';
                            calculateStatisticsForAll();
                          } else {
                            fetchRoomNumbers(newValue);
                            selectedRoom = 'All'; // Reset selected room when department changes
                          }
                        });
                      }
                    },
                    items: departments.map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(value),
                        ),
                      ),
                    ).toList(),
                  ),
                  SizedBox(width: 40),
                  Text(
                    'Salle:',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedRoom,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedRoom = newValue;
                          if (selectedDepartment == 'All' && newValue == 'All') {
                            calculateStatisticsForAll();
                          } else {
                            calculateStatistics();
                          }
                        });
                      }
                    },
                    items: (selectedDepartment != 'All' ? roomNumbersMap[selectedDepartment] ?? ['All'] : ['All']).map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(value),
                        ),
                      ),
                    ).toList(),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:Column(children:[
              Center(child:Text('Pourcentage de panne par indice',style:TextStyle(color: Colors.blueGrey.shade600,fontSize: 20,fontWeight:FontWeight.bold)),),
                SizedBox(height: 10),PieChartWidget(statistics: statistics),],)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:LineChartSample1(selectedDepartment: selectedDepartment), // Pass selected department
        ),
            SizedBox(height: 20),
             Column(children:[
             Center(child:Text('Nombre de panne par département',
                 style:TextStyle(
                     color: Colors.blueGrey.shade600,fontSize: 20,fontWeight:FontWeight.bold
                 ))),
    SizedBox(height: 30),BarChartSample3(),])
     ],
        ),
      ),
    );
  }
}
