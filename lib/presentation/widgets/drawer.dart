import 'package:flutter/material.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/helpers/auth_helper.dart';
import 'package:testt/presentation/widgets/drawer_tile.dart';

import '../../constants/strings.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: ConstColors.main,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 5),
              DrawerTile(title: 'Home', icon: Icons.home_rounded, onTap: () {}),
              const SizedBox(height: 15),
              DrawerTile(
                title: 'Achievements',
                icon: Icons.workspace_premium_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 15),
              DrawerTile(
                title: 'Settings',
                icon: Icons.settings_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 15),
              DrawerTile(
                title: 'About',
                icon: Icons.info_outline,
                onTap: () {},
              ),
              const SizedBox(height: 15),
              DrawerTile(
                title: 'Rate',
                icon: Icons.star_border_rounded,
                onTap: () {},
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  AuthenticationHelper.instance.logout();
                  Navigator.pushReplacementNamed(context, Routes.welcomeRoute);
                },
                child: const Row(
                  children: [
                    SizedBox(width: 15),
                    Icon(Icons.logout_rounded, color: Colors.white, size: 27),
                    SizedBox(width: 20),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'f',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
