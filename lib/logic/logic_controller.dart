import 'package:flutter/material.dart';

class LogicController extends ChangeNotifier {
  // ロジックの管理
  String currentLogic = '時給 + ボトル売上インセンティブ';

  void updateLogic(String newLogic) {
    currentLogic = newLogic;
    notifyListeners();
  }
}