import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Maintenance/models/ChecksModel.dart';

class ChecksService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ChecksModel>> getQuestions(String salleId) async {
    try {
      print('ID de la Salle : $salleId');

      final QuerySnapshot querySnapshot = await _firestore
          .collection('Departements')
          .get();

      for (QueryDocumentSnapshot departement in querySnapshot.docs) {
        final salleSnapshot = await _firestore
            .collection('Departements')
            .doc(departement.id)
            .collection('SallesServeurs')
            .doc(salleId)
            .collection('Questions')
            .get();

        if (salleSnapshot.docs.isNotEmpty) {
          return salleSnapshot.docs.map((doc) {
            return ChecksModel(
              id: doc['id_question'],
              question: doc['question'],
            );
          }).toList();
        }
      }

      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des questions : $e');
    }
  }
}
