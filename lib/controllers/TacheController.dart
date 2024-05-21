import 'package:flutter/material.dart';

import '../models/Tache.dart';
import '../services/TacheService.dart';


class Controller {
  final FirestoreService _service = FirestoreService();

  void fetchTasks(DateTime selectedDay, Function(List<Tache>) callback) async {
    List<Tache> tasks = await _service.fetchTasks(selectedDay);
    callback(tasks);
  }

  void fetchTechnicians(Function(List<String>) callback) async {
    List<String> technicians = await _service.fetchTechnicians();
    callback(technicians);
  }

  void fetchDepartments(Function(List<String>) callback) async {
    List<String> departments = await _service.fetchDepartments();
    callback(departments);
  }

  void fetchSalles(String departmentName, Function(List<String>) callback) async {
    List<String> salles = await _service.fetchSalles(departmentName);
    callback(salles);
  }

  void addTask(String department, String technician, String salle, DateTime date, Function onSuccess, Function onError) async {
    try {
      await _service.addTask(department, technician, salle, date);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }
}
