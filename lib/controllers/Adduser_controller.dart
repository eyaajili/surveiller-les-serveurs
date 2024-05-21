import '../models/Adduser_model.dart';
import '../services/Adduser_service.dart';

class AddUserController {
  final AddUserService _addUserService = AddUserService();

  Future<void> addUser(AddUserModel user) async {
    try {
      await _addUserService.addUser(user);
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'utilisateur : $e');
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur');
    }
  }
}
