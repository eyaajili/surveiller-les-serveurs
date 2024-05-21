import 'package:Maintenance/models/Liste_model.dart';
import 'package:Maintenance/repositories/Liste_repository.dart';

class ListeService {
  final ListeRepository _listRepository = ListeRepository();

  Future<List<ListeModel>> fetchUsers() async {
    return await _listRepository.fetchUsersFromFirestore();
  }
}