import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.nom,
    required this.role,
  }) : super(key: key);

  final String nom, role;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          Icons.person_outlined,
          color: Colors.white,
          size: 37,
        ),
      ),
      title: Text(
        nom,
        style: const TextStyle(color: Colors.white,fontSize:25),
      ),
      subtitle: Text(
        role,
        style: const TextStyle(color: Colors.white,fontSize:25),
      ),
    );
  }
}
