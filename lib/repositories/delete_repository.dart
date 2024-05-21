import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRepository {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('Utilisateurs');

  Future<void> deleteUserByMatricule(String matricule) async {
    try {
      // Recherche de l'utilisateur par son matricule
      QuerySnapshot querySnapshot = await _usersCollection
          .where('matricule', isEqualTo: matricule)
          .get();

      // Vérification s'il existe un utilisateur avec ce matricule
      if (querySnapshot.docs.isNotEmpty) {
        // Suppression de l'utilisateur trouvé
        await _usersCollection.doc(querySnapshot.docs.first.id).delete();
      } else {
        // Aucun utilisateur trouvé avec ce matricule
        throw Exception('Aucun utilisateur trouvé avec ce matricule.');
      }
    } catch (e) {
      print('Erreur lors de la suppression de l\'utilisateur: $e');
      throw e; // Renvoie l'erreur pour une gestion ultérieure
    }
  }
}
