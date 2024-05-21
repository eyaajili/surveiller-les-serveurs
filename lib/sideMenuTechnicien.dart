import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'rive_asset.dart';
import 'rive_utils.dart';
import 'info_card.dart';
import 'side_menu_tile.dart';


class SideMenuTechnicien extends StatefulWidget {
  final String name;
  final String role;

  SideMenuTechnicien({required this.name, required this.role});
  @override
  State<SideMenuTechnicien> createState() => _SideMenuTechnicienState();
}

class _SideMenuTechnicienState extends State<SideMenuTechnicien> {
  RiveAsset? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0xFF17203A),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             SizedBox(width:40), Image.asset('Images/menu.png',height:250,width:200),
                 InfoCard(
                  nom: widget.name,
                  role: widget.role,
                ),
          Padding(
              padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),

                child: Text(
                  "Naviguer".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),

              ...sideMenu3.map(
                    (menu) => SideMenuTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    // Let me show you if the user clicks on the menu how to show the animation
                    StateMachineController controller =
                    RiveUtils.getRiveController(artboard,
                        stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                    // See as we click them it starts to animate
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectedMenu = menu;
                    });
                  },
                  isActive: selectedMenu == menu, nom: widget.name, role:  widget.role,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),),
              ...sideMenu4.map(
                    (menu) => SideMenuTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    StateMachineController controller =
                    RiveUtils.getRiveController(artboard,
                        stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectedMenu = menu;
                    });
                  },
                  isActive: selectedMenu == menu, nom: widget.name, role: widget.role,
                ),
              ),
            ],

          ),

        ),
      ),
    );
  }
}
