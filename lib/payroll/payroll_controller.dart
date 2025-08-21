import 'package:flutter/material.dart';

class PayrollController extends ChangeNotifier {
  // 給料データの管理
  List<String> payrolls = [
    '山田 太郎: ¥120,000',
    '佐藤 花子: ¥110,000',
    '鈴木 一郎: ¥105,000',
  ];
}