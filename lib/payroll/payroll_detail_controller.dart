import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PayrollDetailController extends ChangeNotifier {
  final String memberId;
  Map<String, dynamic>? member;
  List<Map<String, dynamic>> sales = [];
  List<Map<String, dynamic>> salesItems = [];
  Map<String, dynamic> bottles = {};
  List<Map<String, dynamic>> workTimes = [];
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

    // sales_items取得
    final salesIds = sales.map((s) => s['id']).toList();
    salesItems = List<Map<String, dynamic>>.from(
      await supabase
          .from('sales_items')
          .select()
          .filter('sales_id', 'in', salesIds),
    );

// 今月の勤務時間取得
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    workTimes = List<Map<String, dynamic>>.from(
      await supabase
          .from('work_times')
          .select()
          .eq('member_id', memberId)
          .gte('date', firstDay.toIso8601String())
          .lte('date', lastDay.toIso8601String()),
    );

    isLoading = false;
    notifyListeners();
  }

  double get totalWorkHours {
    return workTimes.fold<double>(0, (sum, wt) => sum + (wt['hours'] ?? 0));
  }

  int get baseSalary {
    final hourlyWage = member?['hourly_wage'] ?? 0;
    return (hourlyWage * totalWorkHours).round();
  }

  double get incentiveTotal {
    double total = 0;
    for (var item in salesItems) {
      final bottle = bottles[item['bottle_id']];
      final rate = bottle?['incentive_rate'] ?? 0.0;
      final price = bottle?['price'] ?? 0;
      final quantity = item['quantity'] ?? 0;
      total += price * quantity * rate;
    }
    return total;
  }

  double get totalSalary => baseSalary + incentiveTotal;

  List<String> get calculationDetails {
    List<String> details = [];
    for (var item in salesItems) {
      final bottle = bottles[item['bottle_id']];
      final rate = (bottle?['incentive_rate'] ?? 0.0) as num;
      final price = (bottle?['price'] ?? 0) as num;
      final quantity = (item['quantity'] ?? 0) as num;
      final bottleName = bottle?['name'] ?? '';
      details.add(
          '$bottleName: ¥$price × $quantity × インセンティブ${(rate * 100).toStringAsFixed(1)}% = ${(price * quantity * rate).toStringAsFixed(0)}円');
    }
    return details;
  }
}
