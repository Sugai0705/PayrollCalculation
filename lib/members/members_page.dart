import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'members_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final wageController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => MembersController(),
      child: Consumer<MembersController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: Text('メンバー一覧')),
            body: controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (controller.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(controller.errorMessage!, style: TextStyle(color: Colors.red)),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.members.length,
                          itemBuilder: (context, index) {
                            final member = controller.members[index];
                            return ListTile(
                              title: Text(member['name'] ?? ''),
                              subtitle: Text('時給: ${member['hourly_wage'] ?? ''}円'),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(labelText: '名前'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: wageController,
                                decoration: InputDecoration(labelText: '時給'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final name = nameController.text;
                                final wage = int.tryParse(wageController.text) ?? 0;
                                if (name.isNotEmpty && wage > 0) {
                                  await controller.addMember(name, wage);
                                  nameController.clear();
                                  wageController.clear();
                                }
                              },
                              child: Text('追加'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}