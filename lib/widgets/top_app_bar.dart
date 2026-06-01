import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final String? avatarUrl;

  const TopAppBar({
    super.key,
    required this.title,
    this.leading,
    this.avatarUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                if (leading != null)
                  leading!
                else
                  const Icon(
                    Icons.sports_soccer,
                    color: AppTheme.primaryContainer,
                    size: 28,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Archivo Narrow',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryContainer,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryContainer.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: avatarUrl != null
                        ? Image.network(avatarUrl!, fit: BoxFit.cover)
                        : const Icon(
                            Icons.person,
                            color: AppTheme.onSurfaceVariant,
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
