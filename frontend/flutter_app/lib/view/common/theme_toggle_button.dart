import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => false);

class ThemeToggleButton extends ConsumerStatefulWidget {
  const ThemeToggleButton({super.key});

  @override
  ConsumerState<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends ConsumerState<ThemeToggleButton> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider); // isDarkMode の状態を監視
    final isDarkModeNotifier =
        ref.watch(isDarkModeProvider.notifier); // isDarkMode を更新するための notifier

    return IconButton(
      onPressed: () {
        setState(() {
          isDarkModeNotifier.state = !isDarkMode;
          _saveThemeMode(!isDarkMode); // 設定を保存
        });
      },
      icon: Icon(
        isDarkMode ? Icons.brightness_7 : Icons.brightness_3, // アイコンを変更
        color: Theme.of(context).iconTheme.color, // テーマに合わせた色
      ),
    );
  }
}
