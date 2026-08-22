import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    final email = user?.email ?? "No email available";

    final displayName =
        user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!
            : "Fitness User";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),
            children: [
              // PROFILE HEADER
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary
                          .withOpacity(0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: theme
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onPrimary,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.75),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Fitness Journey",
                              style: TextStyle(
                                color: theme
                                    .colorScheme
                                    .onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              _sectionTitle(context, "Account"),

              const SizedBox(height: 10),

              _settingsCard(
                context,
                children: [
                  _settingsTile(
                    context,
                    icon: Icons.person_outline,
                    iconColor: Colors.green,
                    title: "Personal Information",
                    subtitle:
                        "Manage your fitness profile",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Personal information will be available here.",
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _settingsTile(
                    context,
                    icon: Icons.security_outlined,
                    iconColor: Colors.blue,
                    title: "Account & Security",
                    subtitle: "Manage your account",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Account settings will be available here.",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              _sectionTitle(context, "Appearance"),

              const SizedBox(height: 10),

              _settingsCard(
                context,
                children: [
                  _settingsTile(
                    context,
                    icon: Icons.palette_outlined,
                    iconColor: Colors.deepPurple,
                    title: "App Theme",
                    subtitle: _currentThemeName(),
                    onTap: () {
                      _showThemeSelector(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              _sectionTitle(context, "App"),

              const SizedBox(height: 10),

              _settingsCard(
                context,
                children: [
                  _settingsTile(
                    context,
                    icon: Icons.notifications_none,
                    iconColor: Colors.orange,
                    title: "Notifications",
                    subtitle:
                        "Manage app notifications",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Notification settings will be available here.",
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _settingsTile(
                    context,
                    icon: Icons.info_outline,
                    iconColor: Colors.teal,
                    title: "About",
                    subtitle: "Fitness App",
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "Fitness App",
                        applicationVersion: "1.0.0",
                        applicationLegalese:
                            "Your personal fitness companion.",
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        theme.colorScheme.error,
                    side: BorderSide(
                      color: theme.colorScheme.error
                          .withOpacity(0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "Fitness App • Version 1.0.0",
                  style: TextStyle(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Theme.of(context)
            .colorScheme
            .onSurface,
      ),
    );
  }

  Widget _settingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          subtitle,
          style: TextStyle(
            color:
                theme.colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _currentThemeName() {
    if (themeController.oceanTheme) {
      return "Ocean";
    }

    if (themeController.themeMode ==
        ThemeMode.dark) {
      return "Dark";
    }

    return "Light";
  }

  void _showThemeSelector(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: themeController,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                5,
                20,
                30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose Theme",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Personalize the look of your app",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),

                  _themeOption(
                    context,
                    icon: Icons.light_mode,
                    title: "Light",
                    subtitle:
                        "Classic green fitness theme",
                    selected:
                        !themeController.oceanTheme &&
                            themeController
                                    .themeMode ==
                                ThemeMode.light,
                    color: Colors.green,
                    onTap: () {
                      themeController.setTheme(
                        ThemeMode.light,
                      );
                      Navigator.pop(context);
                    },
                  ),

                  _themeOption(
                    context,
                    icon: Icons.dark_mode,
                    title: "Dark",
                    subtitle:
                        "Comfortable for night use",
                    selected:
                        !themeController.oceanTheme &&
                            themeController
                                    .themeMode ==
                                ThemeMode.dark,
                    color: Colors.deepPurple,
                    onTap: () {
                      themeController.setTheme(
                        ThemeMode.dark,
                      );
                      Navigator.pop(context);
                    },
                  ),

                  _themeOption(
                    context,
                    icon: Icons.water_drop,
                    title: "Ocean",
                    subtitle:
                        "Clean blue fitness theme",
                    selected:
                        themeController.oceanTheme,
                    color: Colors.blue,
                    onTap: () {
                      themeController.setOceanTheme();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _themeOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected
            ? color.withOpacity(0.10)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              selected ? color : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: selected
            ? Icon(
                Icons.check_circle,
                color: color,
              )
            : const Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey,
              ),
      ),
    );
  }
}