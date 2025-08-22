import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payroll_controller.dart';
import 'package:go_router/go_router.dart';

class PayrollPage extends StatefulWidget {
  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  bool showSearch = false;
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PayrollController(),
      child: Consumer<PayrollController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('給料一覧'),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      showSearch = !showSearch;
                      if (!showSearch) {
                        searchController.clear();
                        controller.searchMembers('');
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: () {
                    setState(() {
                      controller.sortByPosition();
                    });
                  },
                ),
              ],
              bottom: showSearch
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(56.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            controller.searchMembers(value);
                          },
                          decoration: InputDecoration(
                            hintText: '名前で検索',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            body: ListView.builder(
              itemCount: controller.members.length,
              itemBuilder: (context, index) {
                final member = controller.members[index];
                final memberId = member['id'];
                return ListTile(
                  title: Text(member['name'] ?? ''),
                  onTap: () {
                    context.go('/payroll/detail/$memberId');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
