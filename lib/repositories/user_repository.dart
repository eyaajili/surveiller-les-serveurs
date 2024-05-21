// user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> authenticateUser(String nom, String motdepasse) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Utilisateurs')
          .where('nom', isEqualTo: nom)
          .where('motdepasse', isEqualTo: motdepasse)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        return User(
          nom: userData['nom'],
          motdepasse: userData['motdepasse'],
          role: userData['role'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de l\'authentification de l\'utilisateur : $e');
      return null;
    }
  }
}
