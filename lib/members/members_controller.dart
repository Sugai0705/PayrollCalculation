import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersController extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> members = [];
  bool isLoading = false;
  String? errorMessage;

  MembersController() {
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await supabase.from('members').select().then((data) {
        members = List<Map<String, dynamic>>.from(data);
      });
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addMember(String name, int hourlyWage) async {
    try {
      await supabase
          .from('members')
          .insert({'name': name, 'hourly_wage': hourlyWage});
      await fetchMembers();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
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
