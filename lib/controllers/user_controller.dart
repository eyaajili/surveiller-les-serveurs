// user_controller.dart
import '../repositories/user_repository.dart';
import '../models/user_model.dart';

class UserController {
  final UserRepository _userRepository = UserRepository();

  Future<User?> authenticateUser(String nom, String motdepasse) async {
    return await _userRepository.authenticateUser(nom, motdepasse);
  }
}
