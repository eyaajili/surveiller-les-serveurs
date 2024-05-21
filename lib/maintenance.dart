import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'camera.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class maintenance extends StatefulWidget {
  final String numeroSalle;
  final String nomDepartement;
  final String nomUtilisateur;
  final String idSalle;

  maintenance({
    required this.numeroSalle,
    required this.nomDepartement,
    required this.nomUtilisateur,
    required this.idSalle,
  });

  @override
  _MaintenanceState createState() => _MaintenanceState();
}

class _MaintenanceState extends State<maintenance> {
  List<String> questionTypes = [];
  int currentQuestionIndex = 0;
  Map<int, Map<String, dynamic>> verifications = {};
  String? takenImagePath;
  bool isOk = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Departements').get();

      for (QueryDocumentSnapshot departementDoc in querySnapshot.docs) {
        QuerySnapshot sallesSnapshot = await FirebaseFirestore.instance
            .collection('Departements')
            .doc(departementDoc.id)
            .collection('SallesServeurs')
            .where('id_salle', isEqualTo: widget.idSalle)
            .get();

        if (sallesSnapshot.docs.isNotEmpty) {
          QuerySnapshot salleDoc = await FirebaseFirestore.instance
              .collection('Departements')
              .doc(departementDoc.id)
              .collection('SallesServeurs')
              .where('id_salle', isEqualTo: widget.idSalle)
              .get();

          if (salleDoc.docs.isNotEmpty) {
            DocumentSnapshot document = salleDoc.docs.first;

            List<dynamic> questions = document['Questions'];

            await fetchQuestionTypes(questions);

            break;
          } else {
            print('La salle correspondante à l\'ID ${widget.idSalle} dans le département ${departementDoc.id} n\'existe pas.');
          }
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des questions : $e');
    }
  }

  Future<void> fetchQuestionTypes(List<dynamic> questions) async {
    try {
      for (var idQuestion in questions) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Questions')
            .where('id_question', isEqualTo: idQuestion)
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String typeQuestion = doc['type_question'];
          if (!questionTypes.contains(typeQuestion)) {
            setState(() {
              questionTypes.add(typeQuestion);
            });
          }
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des types de questions : $e');
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      firebase_storage.TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erreur lors du téléversement de l\'image : $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questionTypes.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (currentQuestionIndex < questionTypes.length) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              takenImagePath != null
                  ? Image.file(File(takenImagePath!))
                  : Image.asset('Images/maintenance.png', width: 250),
              SizedBox(height: 20),
              takenImagePath != null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green, size: 50),
                    onPressed: () {
                      nextQuestion(isOk);
                    },
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.black, size: 50),
                    onPressed: () {
                      takePicture();
                    },
                  ),
                ],
              )
                  : Container(
                width: 350,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.blue.shade900.withOpacity(1),
                    width: 4,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Quelle est l\'état actuel de ${questionTypes[currentQuestionIndex]}  ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue.shade800,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red, size: 50),
                          onPressed: () {
                            isOk = false;
                            takePicture();


                          },
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green, size: 50),
                          onPressed: () {
                            isOk = true;
                            takePicture();

                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text('Vérification terminée !'),
        ),
      );
    }
  }

  Future<void> takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: firstCamera, onPictureTaken: (imagePath) {
          setState(() {
            takenImagePath = imagePath;
          });
        }),
      ),
    );

    if (imagePath != null) {
      setState(() {
        takenImagePath = imagePath;
      });
    }
  }

  void nextQuestion(bool isOk) async {
    String etat = isOk ? 'ok' : 'nonok';

    if (takenImagePath != null) {
      String imageUrl = await uploadImageToStorage(File(takenImagePath!));
      verifications[currentQuestionIndex] = {
        'etat': etat,
        'photoUrl': imageUrl,
        'type': questionTypes[currentQuestionIndex],
      };

      setState(() {
        if (currentQuestionIndex < questionTypes.length - 1) {
          currentQuestionIndex++;
          takenImagePath = null;
        } else {
          showCommentDialog();
        }
      });
    } else {
      takePicture();
    }
  }


  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String comment = '';
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Text("Visite terminée"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ajouter un commentaire',
                  ),
                  onChanged: (value) {
                    comment = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance.collection('Visite').add({
                        'Date': DateTime.now(),
                        'Commentaire': comment,
                        'nom': widget.nomUtilisateur,
                        'nom_departement': widget.nomDepartement,
                        'numéro_salle': widget.numeroSalle,
                        'Vérification': verifications.values.toList(),
                      });

                      print('Données enregistrées avec succès dans Firestore');

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Erreur lors de l\'enregistrement des données : $e');
                    }
                  },
                ),
                TextButton(
                  child: Text("Annuler"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }}
