import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'members_add_controller.dart';

class MembersAddPage extends StatefulWidget {
  @override
  State<MembersAddPage> createState() => _MembersAddPageState();
}

class _MembersAddPageState extends State<MembersAddPage> {
  final nameController = TextEditingController();
  final wageController = TextEditingController();
  String? selectedPosition;

  final positions = [
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MembersAddController(),
      child: Consumer<MembersAddController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: Text('メンバー追加')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '名前'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: wageController,
                    decoration: InputDecoration(labelText: '時給'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPosition,
                    items: positions
                        .map((pos) => DropdownMenuItem(
                              value: pos['value'],
                              child: Text(pos['label']!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPosition = value;
                      });
                    },
                    decoration: InputDecoration(labelText: '役職'),
                  ),
                  SizedBox(height: 24),
                  if (controller.errorMessage != null)
                    Text(controller.errorMessage!,
                        style: TextStyle(color: Colors.red)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              final name = nameController.text;
                              final wage =
                                  int.tryParse(wageController.text) ?? 0;
                              final position = selectedPosition ?? '';
                              if (name.isNotEmpty &&
                                  wage > 0 &&
                                  position.isNotEmpty) {
                                await controller.addMember(
                                    name, wage, position);
                                if (controller.errorMessage == null) {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                      child: controller.isLoading
                          ? CircularProgressIndicator()
                          : Text('登録'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
