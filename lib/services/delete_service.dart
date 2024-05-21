import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteService {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('utilisateurs');

  Future<void> deleteUserByMatricule(String matricule) async {
    QuerySnapshot querySnapshot =
    await _usersCollection.where('matricule', isEqualTo: matricule).get();

    querySnapshot.docs.forEach((doc) {
      print("deletewelldone");
      doc.reference.delete();
    });
  }
}
