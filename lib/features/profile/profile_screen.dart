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
  if (themeController.glassTheme) {
    return "Transparent Glass";
  }

  if (themeController.oceanTheme) {
    return "Ocean";
  }

  if (themeController.themeMode == ThemeMode.dark) {
    return "Dark";
  }

  return "Light";
}

  void _showThemeSelector(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,

    builder: (bottomSheetContext) {
      return AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          final isLight =
              !themeController.oceanTheme &&
              !themeController.glassTheme &&
              themeController.themeMode == ThemeMode.light;

          final isDark =
              !themeController.oceanTheme &&
              themeController.themeMode == ThemeMode.dark;

          final isOcean = themeController.oceanTheme;

          final isGlass = themeController.glassTheme;

          Widget themeOption({
            required String title,
            required String subtitle,
            required IconData icon,
            required Color iconColor,
            required Color iconBackground,
            required bool selected,
            required VoidCallback onTap,
          }) {
            return InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: iconBackground,
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      selected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      size: 26,
                    ),
                  ],
                ),
              ),
            );
          }

          return FractionallySizedBox(
            heightFactor: 0.85,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),

              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Drag handle
                  Container(
                    width: 55,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Theme",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Personalize the look of your app",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        MediaQuery.of(context).padding.bottom + 24,
                      ),
                      children: [
                        themeOption(
                          title: "Light",
                          subtitle: "Classic green fitness theme",
                          icon: Icons.wb_sunny,
                          iconColor: Colors.green,
                          iconBackground: Colors.green.shade50,
                          selected: isLight,
                          onTap: () {
                            themeController.setTheme(
                              ThemeMode.light,
                            );
                            Navigator.pop(bottomSheetContext);
                          },
                        ),

                        themeOption(
                          title: "Dark",
                          subtitle: "Comfortable for night use",
                          icon: Icons.nightlight_round,
                          iconColor: Colors.deepPurple,
                          iconBackground: Colors.deepPurple.shade50,
                          selected: isDark,
                          onTap: () {
                            themeController.setTheme(
                              ThemeMode.dark,
                            );
                            Navigator.pop(bottomSheetContext);
                          },
                        ),

                        themeOption(
                          title: "Ocean",
                          subtitle: "Clean blue fitness theme",
                          icon: Icons.water_drop,
                          iconColor: Colors.blue,
                          iconBackground: Colors.blue.shade50,
                          selected: isOcean,
                          onTap: () {
                            themeController.setOceanTheme();
                            Navigator.pop(bottomSheetContext);
                          },
                        ),

                        themeOption(
                          title: "Transparent Glass",
                          subtitle: "Premium frosted glass experience",
                          icon: Icons.blur_on,
                          iconColor: Colors.deepPurple,
                          iconBackground: Colors.deepPurple.shade50,
                          selected: isGlass,
                          onTap: () async {
                            await themeController.setGlassTheme();

                            if (bottomSheetContext.mounted) {
                              Navigator.pop(bottomSheetContext);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
              

}
