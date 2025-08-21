import 'package:flutter/material.dart';

class SalesController extends ChangeNotifier {
  // 売上データの管理や入力処理をここに追加
  String? lastInput;

  void submitSales(String value) {
    lastInput = value;
    notifyListeners();
  }
}