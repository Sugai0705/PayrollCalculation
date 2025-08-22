import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersDetailController extends ChangeNotifier {
  final String memberId;
  Map<String, dynamic>? member;
  List<Map<String, dynamic>> sales = [];
  List<Map<String, dynamic>> salesItems = [];
  Map<String, dynamic> bottles = {}; // bottle_id: bottleデータ
  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> workTimes = [];

  MembersDetailController(this.memberId) {
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final supabase = Supabase.instance.client;
      // メンバー情報
      member =
          await supabase.from('members').select().eq('id', memberId).single();
      // 売上（salesテーブル）
      sales = List<Map<String, dynamic>>.from(
        await supabase.from('sales').select().eq('member_id', memberId),
      );
      // sales_items
      final salesIds = sales.map((s) => s['id']).toList();
      salesItems = List<Map<String, dynamic>>.from(
        await supabase
            .from('sales_items')
            .select()
            .filter('sales_id', 'in', salesIds),
      );
      // bottles
      final bottlesData = await supabase.from('bottles').select();
      bottles = {for (var b in bottlesData) b['id']: b};
      // worktime
      workTimes = List<Map<String, dynamic>>.from(
        await supabase.from('work_times').select().eq('member_id', memberId),
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  double getTotalWorkHours() {
    return workTimes.fold<double>(
      0,
      (sum, wt) {
        final hours = wt['hours'];
        if (hours == null) return sum;
        if (hours is num) return sum + hours.toDouble();
        if (hours is String && hours.isNotEmpty) {
          final parsed = double.tryParse(hours);
          return parsed != null ? sum + parsed : sum;
        }
        return sum;
      },
    );
  }
}
