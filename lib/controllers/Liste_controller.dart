import 'package:flutter/material.dart';
import 'package:Maintenance/models/Liste_model.dart';
import 'package:Maintenance/services/Liste_service.dart';

class ListeController {
  final ListeService _listService = ListeService();

  Future<List<ListeModel>> getUsers() async {
    try {
      List<ListeModel> users = await _listService.fetchUsers();
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}