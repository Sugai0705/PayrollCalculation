import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'members_detail_controller.dart';

class MembersDetailPage extends StatelessWidget {
  final String memberId;
  const MembersDetailPage({required this.memberId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MembersDetailController(memberId),
      child: Consumer<MembersDetailController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return Scaffold(
              appBar: AppBar(title: Text('メンバー詳細')),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (controller.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: Text('メンバー詳細')),
              body: Center(child: Text(controller.errorMessage!)),
            );
          }
          final member = controller.member;
          return Scaffold(
            appBar: AppBar(title: Text('メンバー詳細')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: member == null
                  ? Text('メンバー情報がありません')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('名前: ${member['name'] ?? ''}',
                            style: TextStyle(fontSize: 20)),
                        Text('時給: ${member['hourly_wage'] ?? ''}円',
                            style: TextStyle(fontSize: 18)),
                        Text('勤務時間合計: ${controller.getTotalWorkHours()}時間',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 16),
                        Text('売上履歴:', style: TextStyle(fontSize: 18)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.sales.length,
                            itemBuilder: (context, index) {
                              final sale = controller.sales[index];
                              final saleDate = sale['date'];
                              final saleId = sale['id'];
                              final saleItems = controller.salesItems
                                  .where((item) => item['sales_id'] == saleId)
                                  .toList();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('日付: $saleDate',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  ...saleItems.map((item) {
                                    final bottle =
                                        controller.bottles[item['bottle_id']];
                                    final price = bottle?['price'] ?? 0;
                                    final name = bottle?['name'] ?? '';
                                    final quantity = item['quantity'] ?? 0;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                          '$name × $quantity = ${price * quantity}円'),
                                    );
                                  }),
                                ],
                              );
                            },
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
