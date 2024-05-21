import 'package:Maintenance/repositories/delete_repository.dart';

class DeleteController {
  final DeleteRepository _deleteRepository = DeleteRepository();

  Future<bool> deleteUserByMatricule(String matricule) async {
    try {
      await _deleteRepository.deleteUserByMatricule(matricule);
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}
