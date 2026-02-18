import 'package:flutter/material.dart';
import 'package:spelling_hero/core/theme/app_theme.dart';

class CustomKeyboard extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

  const CustomKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
          _buildRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
          _buildRow(['Z', 'X', 'C', 'V', 'B', 'N', 'M'], hasSpecialKeys: true),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys, {bool hasSpecialKeys = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasSpecialKeys)
            _buildSpecialKey(
              icon: Icons.backspace_rounded,
              color: AppTheme.oopsColor,
              onTap: onBackspace,
            ),
          if (hasSpecialKeys) const SizedBox(width: 6),
          for (final key in keys)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: _KeyButton(label: key, onTap: () => onKeyPressed(key)),
              ),
            ),
          if (hasSpecialKeys) const SizedBox(width: 6),
          if (hasSpecialKeys)
            _buildSpecialKey(
              icon: Icons.check_circle_rounded,
              color: AppTheme.vibrantGreen,
              onTap: onSubmit,
            ),
        ],
      ),
    );
  }

  Widget _buildSpecialKey({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 56,
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryIndigo.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepNavy,
                fontFamily: AppTheme.light.textTheme.bodyLarge?.fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
