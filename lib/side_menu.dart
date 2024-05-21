import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'rive_asset.dart';
import 'rive_utils.dart';
import 'info_card.dart';
import 'side_menu_tile.dart';


class SideMenu extends StatefulWidget {
  final String name;
  final String role;

  SideMenu({required this.name, required this.role});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
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

                  Image.asset('Images/menuAdmin.png',height:200,width:300),
                  InfoCard(
                    nom: widget.name,
                    role: widget.role,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                    child: Text(
                      "naviguer".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white70),
                    ),
                  ),
                  ...sideMenus.map(
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
                      isActive: selectedMenu == menu,nom: widget.name, role: widget.role,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                    child: Text(
                      "Activités".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white70),
                    ),
                  ),
                  ...sideMenu2.map(
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
                      isActive: selectedMenu == menu, nom: widget.name, role:widget.role,
                    ),
                  ), Padding(
                    padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),),
                  ...sideMenu1.map(
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
                ])

        ),

      ),
    );
  }
}
