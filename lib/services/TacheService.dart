import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Maintenance/models/Tache.dart';

class FirestoreService {
  Future<List<Tache>> fetchTasks(DateTime selectedDay) async {
    final tasksSnapshot = await FirebaseFirestore.instance
        .collection('Taches')
        .where('Date', isGreaterThanOrEqualTo: _startOfDay(selectedDay))
        .where('Date', isLessThan: _endOfDay(selectedDay))
        .get();

    return tasksSnapshot.docs.map((doc) {
      return Tache(
        department: doc['Departement'],
        technician: doc['nom'],
        salle: doc['Salle'],
        date: (doc['Date'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<List<String>> fetchTechnicians() async {
    final techniciansSnapshot = await FirebaseFirestore.instance
        .collection('Utilisateurs')
        .where('role', isEqualTo: 'technicien')
        .get();

    return [''] + techniciansSnapshot.docs.map((doc) => doc['nom'] as String).toList();
  }

  Future<List<String>> fetchDepartments() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Departements').get();
    return querySnapshot.docs.map((doc) => doc['nom'] as String).toList();
  }

  Future<List<String>> fetchSalles(String departmentName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Departements')
        .where('nom', isEqualTo: departmentName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final departmentDoc = querySnapshot.docs.first;
      final roomNumbersSnapshot = await departmentDoc.reference.collection('SallesServeurs').get();
      return roomNumbersSnapshot.docs.map((doc) => doc['numéro_salle'].toString()).toList();
    }

    return [];
  }

  Future<void> addTask(String department, String technician, String salle, DateTime date) async {
    await FirebaseFirestore.instance.collection('Taches').add({
      'Departement': department,
      'nom': technician,
      'Salle': salle,
      'Date': Timestamp.fromDate(date),
    });
  }

  Timestamp _startOfDay(DateTime day) {
    return Timestamp.fromMillisecondsSinceEpoch(day.millisecondsSinceEpoch);
  }

  Timestamp _endOfDay(DateTime day) {
    return Timestamp.fromMillisecondsSinceEpoch(day.millisecondsSinceEpoch + 86399999);
  }
}
