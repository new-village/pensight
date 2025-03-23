import 'package:flutter/material.dart';

void showManagementMenu(
  BuildContext context,
  bool isDarkMode,
  VoidCallback onToggleDarkMode,
  ValueChanged<double> onFontSizeChanged,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('管理メニュー'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('ダークモード'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                onToggleDarkMode();
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Text('フォントサイズ:'),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      showValueIndicator: ShowValueIndicator.always,
                    ),
                    child: Slider(
                      min: 12,
                      max: 30,
                      divisions: 18,
                      value: 26,
                      label: 26.toStringAsFixed(0),
                      onChanged: (value) => onFontSizeChanged(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
