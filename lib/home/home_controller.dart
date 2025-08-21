import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  // 必要に応じてホーム画面のロジックやデータを追加
  String welcomeMessage = 'ようこそ、給与計算アプリへ！';

  // 売り上げのTOP３を取得するメソッド
  List<String> getTopSales() {
    // ダミーデータ
    return ['商品A', '商品B', '商品C'];
  }
}