import '../models/Adduser_model.dart';
import '../repositories/Adduser_repository.dart';

class AddUserService {
  final AddUserRepository _addUserRepository = AddUserRepository();

  Future<void> addUser(AddUserModel user) async {
    try {
      await _addUserRepository.addUser(user);
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'utilisateur : $e');
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur');
    }
  }
}
