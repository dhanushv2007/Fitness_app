<<<<<<< HEAD
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
=======
import 'package:flutter/material.dart';
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
<<<<<<< HEAD
    final isGlass = themeController.glassTheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(27),
          splashColor: color.withOpacity(0.12),
          highlightColor: Colors.white.withOpacity(0.10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: isGlass ? 22 : 0,
                sigmaY: isGlass ? 22 : 0,
              ),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: isGlass
                      ? Colors.white.withOpacity(0.43)
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(27),
                  border: isGlass
                      ? Border.all(
                          color: Colors.white.withOpacity(0.88),
                          width: 1.35,
                        )
                      : null,
                  gradient: isGlass
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.64),
                            Colors.white.withOpacity(0.25),
                          ],
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isGlass
                          ? color.withOpacity(0.13)
                          : color.withOpacity(0.15),
                      blurRadius: isGlass ? 24 : 18,
                      offset: const Offset(0, 9),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (isGlass)
                      Positioned(
                        top: -28,
                        right: -25,
                        child: IgnorePointer(
                          child: Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withOpacity(0.72),
                                  Colors.white.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(isGlass ? 0.16 : 0.12),
                            borderRadius: BorderRadius.circular(17),
                            border: isGlass
                                ? Border.all(
                                    color: Colors.white.withOpacity(0.65),
                                  )
                                : null,
                          ),
                          child: Icon(icon, color: color, size: 27),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
=======

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.15),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 8c6adcddfc657ba0464891256e4e0998a4836294
