import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sales_controller.dart';

class SalesPage extends StatefulWidget {
  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final dateController = TextEditingController();
  DateTime? selectedDate;
  Map<String, int> bottleQuantities = {};

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalesController(),
      child: Consumer<SalesController>(
        builder: (context, controller, _) {
          // 商品リストが変わったら初期化
          for (var bottle in controller.bottles) {
            bottleQuantities.putIfAbsent(bottle['id'].toString(), () => 0);
          }
          return Scaffold(
            appBar: AppBar(title: Text('売上登録')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // メンバー・日付選択をカードでまとめる
                  Card(
                    elevation: 2,
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('メンバー',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 16),
                              Expanded(
                                child: DropdownButton<int?>(
                                  value: controller.selectedMemberId,
                                  isExpanded: true,
                                  items: controller.members
                                      .map((m) => DropdownMenuItem<int>(
                                            value: m['id'] as int,
                                            child: Text(m['name'] ?? ''),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    controller.selectedMemberId = value;
                                    controller.notifyListeners();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text('日付',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  selectedDate == null
                                      ? '未選択'
                                      : '${selectedDate!.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      selectedDate = picked;
                                    });
                                  }
                                },
                                child: Text('選択'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('商品ごとの個数',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.bottles.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final bottle = controller.bottles[index];
                        final bottleId = bottle['id'].toString();
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                  '${bottle['name']}（¥${bottle['price']}）'),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  bottleQuantities[bottleId] =
                                      (bottleQuantities[bottleId] ?? 0) > 0
                                          ? (bottleQuantities[bottleId]! - 1)
                                          : 0;
                                });
                              },
                            ),
                            Text('${bottleQuantities[bottleId] ?? 0}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  bottleQuantities[bottleId] =
                                      (bottleQuantities[bottleId] ?? 0) + 1;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading ||
                              controller.selectedMemberId == null
                          ? null
                          : () async {
                              final filtered = Map.fromEntries(
                                bottleQuantities.entries
                                    .where((e) => e.value > 0),
                              );
                              if (selectedDate == null) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('エラー'),
                                    content: Text('日付を選択してください。'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                              if (filtered.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('エラー'),
                                    content: Text('商品を1つ以上選択してください。'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                              await controller.addSale(
                                memberId: controller.selectedMemberId!,
                                date: selectedDate!,
                                bottleQuantities: filtered,
                              );
                              setState(() {
                                bottleQuantities.updateAll((key, value) => 0);
                                selectedDate = null;
                              });
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('登録完了'),
                                  content: Text('売上登録が完了しました。'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: Text('登録'),
                    ),
                  ),
                  if (controller.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(controller.errorMessage!,
                          style: TextStyle(color: Colors.red)),
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
