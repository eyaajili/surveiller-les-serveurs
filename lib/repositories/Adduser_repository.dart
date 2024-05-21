import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Adduser_model.dart';

class AddUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(AddUserModel user) async {
    try {
      await _firestore.collection('Utilisateurs').add({
        'nom': user.nom,
        'motdepasse': user.motdepasse,
        'role': user.role,
        'matricule': user.matricule,
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'utilisateur : $e');
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur');
    }
  }
}
