import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payroll_controller.dart';

class PayrollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PayrollController(),
      child: Consumer<PayrollController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: Text('給料一覧')),
            body: ListView.builder(
              itemCount: controller.payrolls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.payrolls[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}