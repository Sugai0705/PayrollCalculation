import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersController extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allMembers = [];
  List<Map<String, dynamic>> members = [];
  bool isLoading = false;
  String? errorMessage;

  // 役職マッピング（英語名:日本語名）
  static const positions = [
    {'value': 'owner', 'label': 'オーナー'},
    {'value': 'manager', 'label': 'マネージャー'},
    {'value': 'sub_manager', 'label': 'サブマネージャー'},
    {'value': 'chief', 'label': 'チーフ'},
    {'value': 'staff', 'label': '黒服'},
    {'value': 'boy', 'label': 'ボーイ'},
    {'value': 'executive', 'label': '幹部'},
    {'value': 'hostess', 'label': 'キャバ嬢'},
    {'value': 'help', 'label': 'ヘルプ'},
    {'value': 'shop_manager', 'label': '店長'},
  ];

  static String getPositionLabel(String? value) {
    return positions.firstWhere(
          (pos) => pos['value'] == value,
          orElse: () => {'label': value ?? ''},
        )['label'] ??
        '';
  }

  MembersController() {
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await supabase.from('members').select();
      allMembers = List<Map<String, dynamic>>.from(data);
      members = List<Map<String, dynamic>>.from(allMembers);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void sortByPosition() {
    members.sort((a, b) {
      final posA = a['position'] ?? '';
      final posB = b['position'] ?? '';
      final idxA = positions.indexWhere((p) => p['value'] == posA);
      final idxB = positions.indexWhere((p) => p['value'] == posB);
      return idxA.compareTo(idxB);
    });
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

  Future<void> updateMember(int id, String name, int hourlyWage) async {
    try {
      await supabase
          .from('members')
          .update({'name': name, 'hourly_wage': hourlyWage}).eq('id', id);
      await fetchMembers();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMember(int id) async {
    try {
      await supabase.from('members').delete().eq('id', id);
      await fetchMembers();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
