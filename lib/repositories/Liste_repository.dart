import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Maintenance/models/Liste_model.dart';

class ListeRepository {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('Utilisateurs');

  Future<List<ListeModel>> fetchUsersFromFirestore() async {
    QuerySnapshot querySnapshot = await _usersCollection.get();
    List<ListeModel> users = querySnapshot.docs.map((doc) {
      return ListeModel(
        nom: doc['nom'] ?? '',
        matricule: doc['matricule'] ?? '',
        role: doc['role'] ?? '',
      );
    }).toList();
    return users;
  }
}