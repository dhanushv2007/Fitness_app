import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          final isDark =
              !themeController.oceanTheme &&
              themeController.themeMode == ThemeMode.dark;

          final isLight =
              !themeController.oceanTheme &&
              themeController.themeMode == ThemeMode.light;

          final isOcean =
              themeController.oceanTheme;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),

              const Center(
                child: CircleAvatar(
                  radius: 45,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "App Theme",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ListTile(
                        leading: const Icon(
                          Icons.light_mode,
                        ),
                        title: const Text("Light"),
                        subtitle: const Text(
                          "Green light theme",
                        ),
                        trailing: isLight
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          themeController.setTheme(
                            ThemeMode.light,
                          );
                        },
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.dark_mode,
                        ),
                        title: const Text("Dark"),
                        subtitle: const Text(
                          "Dark mode",
                        ),
                        trailing: isDark
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          themeController.setTheme(
                            ThemeMode.dark,
                          );
                        },
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.water_drop,
                        ),
                        title: const Text("Ocean"),
                        subtitle: const Text(
                          "Blue fitness theme",
                        ),
                        trailing: isOcean
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              )
                            : null,
                        onTap: () {
                          themeController.setOceanTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}