import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../members/members_controller.dart'; // 役職ラベル・positions利用

class PayrollController extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allMembers = [];
  List<Map<String, dynamic>> members = [];
  Map<int, double> payrolls = {}; // memberId: salary
  bool isLoading = false;
  String? errorMessage;

  PayrollController() {
    fetchPayrolls();
  }

  Future<void> fetchPayrolls() async {
    isLoading = true;
    notifyListeners();
    try {
      // Supabase等からメンバー・給料データ取得
      final memberData = await supabase.from('members').select();
      final payrollData = await supabase.from('payroll').select();
      allMembers = List<Map<String, dynamic>>.from(memberData);
      members = List<Map<String, dynamic>>.from(allMembers);
      payrolls = Map<int, double>.fromIterable(
        payrollData,
        key: (item) => item['member_id'],
        value: (item) => item['salary']?.toDouble() ?? 0,
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void searchMembers(String keyword) {
    if (keyword.isEmpty) {
      members = List<Map<String, dynamic>>.from(allMembers);
    } else {
      members = allMembers
          .where((m) => (m['name'] ?? '')
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void sortByPosition() {
    members.sort((a, b) {
      final posA = a['position'] ?? '';
      final posB = b['position'] ?? '';
      final idxA =
          MembersController.positions.indexWhere((p) => p['value'] == posA);
      final idxB =
          MembersController.positions.indexWhere((p) => p['value'] == posB);
      return idxA.compareTo(idxB);
    });
    notifyListeners();
  }
}
