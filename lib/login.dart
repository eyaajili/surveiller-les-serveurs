import 'package:flutter/material.dart';
import 'EntryPoint.dart';
import 'EntryPoint2.dart';
import 'package:Maintenance/controllers/user_controller.dart';
import 'package:Maintenance/models/user_model.dart';

class loginpage extends StatefulWidget {
  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final formKey = GlobalKey<FormState>();
  String? nom;
  String? motdepasse;
  bool isLoading = false;
  String? errorMessage;
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100),
                Image.asset(
                  'Images/login.png',
                  width: 400,
                  height: 300,
                ),
                Row(
                  children: [
                    Text(
                      '      Bienvenue',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue.shade800,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'Images/wave.png',
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Accédez à votre salle de serveurs en un clic',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                if (errorMessage != null) ...[
                  SizedBox(height: 20),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nom Utilisateur',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        size: 35,
                        color: Colors.black87,
                      ),
                    ),
                    validator: (value) {
                      nom = value;
                      if (value!.isEmpty) {
                        return 'Entrez votre nom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 35,
                        color: Colors.black87,
                      ),
                    ),
                    validator: (value) {
                      motdepasse = value;
                      if (value!.isEmpty) {
                        return 'Entrez votre mot de passe';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 40),
                if (isLoading)
                  CircularProgressIndicator()
                else
                  Container(
                    width: 140,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.blue.shade800,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade900.withOpacity(1),
                          spreadRadius: 2,
                          offset: Offset(0.5, 3),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          User? authenticatedUser = await _userController.authenticateUser(nom!, motdepasse!);
                          setState(() {
                            isLoading = false;
                          });
                          if (authenticatedUser != null) {
                            if (authenticatedUser.role.toLowerCase().contains("admin")) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EntryPoint(
                                    name: authenticatedUser.nom,
                                    role: authenticatedUser.role,
                                  ),
                                ),
                              );
                            } else {
                              nom = authenticatedUser.nom;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EntryPoint2(
                                    name: authenticatedUser.nom,
                                    role: authenticatedUser.role,
                                  ),
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              errorMessage = 'Nom d\'utilisateur ou mot de passe incorrect.';
                            });
                          }
                        }
                      },
                      child: Text(
                        'Se Connecter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
