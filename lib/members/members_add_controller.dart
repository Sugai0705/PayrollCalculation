import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Supabase等のパッケージをimportしてください

class MembersAddController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<void> addMember(String name, int wage, String position) async {
    final supabase = Supabase.instance.client;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await supabase.from('members').insert({
        'name': name,
        'hourly_wage': wage,
        'position': position,
      });
    } catch (e) {
      errorMessage = '追加に失敗しました';
    }
    isLoading = false;
    notifyListeners();
  }
}
