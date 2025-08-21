import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sales_controller.dart';

class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalesController(),
      child: Consumer<SalesController>(
        builder: (context, controller, _) {
          final salesController = TextEditingController();
          return Scaffold(
            appBar: AppBar(title: Text('売上入力')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: salesController,
                    decoration: InputDecoration(labelText: '売上金額を入力'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.submitSales(salesController.text);
                      salesController.clear();
                    },
                    child: Text('登録'),
                  ),
                  if (controller.lastInput != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('直近の入力: ${controller.lastInput}'),
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