// firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeApp() async {
    await Firebase.initializeApp();
  }

  FirebaseFirestore get firestore => _firestore;
}
