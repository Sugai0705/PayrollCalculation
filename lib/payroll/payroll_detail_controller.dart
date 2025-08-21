import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PayrollDetailController extends ChangeNotifier {
  final String memberId;
  Map<String, dynamic>? member;
  List<Map<String, dynamic>> sales = [];
  Map<String, dynamic> bottles = {};
  bool isLoading = true;

  PayrollDetailController(this.memberId) {
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final supabase = Supabase.instance.client;
    member =
        await supabase.from('members').select().eq('id', memberId).single();
    sales = List<Map<String, dynamic>>.from(
      await supabase.from('sales').select().eq('member_id', memberId),
    );
    final bottlesData = await supabase.from('bottles').select();
    bottles = {for (var b in bottlesData) b['id']: b};
    isLoading = false;
    notifyListeners();
  }

  int get baseSalary => (member?['hourly_wage'] ?? 0) * 160;

  double get incentiveTotal {
    double total = 0;
    for (var sale in sales) {
      final bottle = bottles[sale['bottle_id']];
      final rate = bottle?['incentive_rate'] ?? 0.0;
      total += (sale['amount'] ?? 0) * rate;
    }
    return total;
  }

  double get totalSalary => baseSalary + incentiveTotal;

  List<String> get calculationDetails {
    List<String> details = [];
    for (var sale in sales) {
      final bottle = bottles[sale['bottle_id']];
      final rate = (bottle?['incentive_rate'] ?? 0.0) as num;
      final amount = (sale['amount'] ?? 0) as num;
      final bottleName = bottle?['name'] ?? '';
      details.add(
          '売上${amount}円 × ${bottleName}インセンティブ${(rate * 100).toStringAsFixed(1)}% = ${(amount * rate).toStringAsFixed(0)}円');
    }
    return details;
  }
}
