import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const GlobalNavigationBar({
    required this.currentIndex,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'メンバー'),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: '売上'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: '給料'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ロジック'),
      ],
    );
  }
}
