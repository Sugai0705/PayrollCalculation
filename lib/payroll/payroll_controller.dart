import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PayrollController extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> members = [];
  Map<String, double> payrolls = {}; // memberId: 給料

  PayrollController() {
    fetchPayrolls();
  }

  Future<void> fetchPayrolls() async {
    final membersData = await supabase.from('members').select();
    final salesData = await supabase.from('sales').select();
    final bottlesData = await supabase.from('bottles').select();

    members = List<Map<String, dynamic>>.from(membersData);
    final bottlesMap = {
      for (var b in bottlesData) b['id']: b['incentive_rate']
    };

    payrolls.clear();
    for (var member in members) {
      final memberId = member['id'];
      final hourlyWage = member['hourly_wage'] ?? 0;
      final baseSalary = hourlyWage * 160;

      final memberSales = salesData.where((s) => s['member_id'] == memberId);
      double incentiveTotal = 0;
      for (var sale in memberSales) {
        final bottleRate = bottlesMap[sale['bottle_id']] ?? 0.0;
        incentiveTotal += (sale['amount'] ?? 0) * bottleRate;
      }
      payrolls[memberId] = baseSalary + incentiveTotal;
    }
    notifyListeners();
  }
}
