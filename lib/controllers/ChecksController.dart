import 'dart:async';
import 'package:Maintenance/repositories/ChecksRepository.dart';
import 'package:Maintenance/models/ChecksModel.dart';

class ChecksController {
  final ChecksRepository _repository = ChecksRepository();
  final StreamController<List<ChecksModel>> _questionsStreamController =
  StreamController<List<ChecksModel>>();

  Stream<List<ChecksModel>> get questionsStream =>
      _questionsStreamController.stream;

  void getQuestions(String salleId) async {
    try {
      final List<ChecksModel> questions =
      await _repository.getQuestions(salleId);
      _questionsStreamController.add(questions);
      print('test dans le control est ');
    } catch (e) {
      _questionsStreamController.addError(e);
    }
  }

  void answerQuestion(String questionId, bool answer) {
    // Logique pour enregistrer la réponse dans Firestore
  }

  void dispose() {
    _questionsStreamController.close();
  }
}
