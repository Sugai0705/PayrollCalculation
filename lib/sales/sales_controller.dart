import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalesController extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoading = false;
  String? errorMessage;

  List<Map<String, dynamic>> members = [];
  String? selectedMemberId;

  List<Map<String, dynamic>> bottles = [];
  String? selectedBottleId;

  SalesController() {
    fetchMembers();
    fetchBottles();
  }

  Future<void> fetchMembers() async {
    try {
      final data = await supabase.from('members').select();
      members = List<Map<String, dynamic>>.from(data);
      if (members.isNotEmpty) {
        selectedMemberId = members.first['id'].toString();
      }
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchBottles() async {
    try {
      final data = await supabase.from('bottles').select();
      bottles = List<Map<String, dynamic>>.from(data);
      if (bottles.isNotEmpty) {
        selectedBottleId = bottles.first['id'].toString();
      }
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addSale({
    required String memberId,
    required DateTime date,
    required Map<String, int> bottleQuantities, // bottle_id: quantity
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      // salesテーブルにinsert
      final salesRes = await supabase
          .from('sales')
          .insert({
            'member_id': memberId,
            'date': date.toIso8601String(),
          })
          .select()
          .single();
      final salesId = salesRes['id'];

      // sales_itemsテーブルにinsert
      for (final entry in bottleQuantities.entries) {
        await supabase.from('sales_items').insert({
          'sales_id': salesId,
          'bottle_id': entry.key,
          'quantity': entry.value,
        });
      }
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
