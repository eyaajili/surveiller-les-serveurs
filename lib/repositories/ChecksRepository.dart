import 'package:Maintenance/repositories/ChecksRepository.dart';
import 'package:Maintenance/services/ChecksService.dart';
import 'package:Maintenance/models/ChecksModel.dart';

class ChecksRepository {
  final ChecksService _service = ChecksService();

  Future<List<ChecksModel>> getQuestions(String salleId) async {
    return await _service.getQuestions(salleId);
  }
}
