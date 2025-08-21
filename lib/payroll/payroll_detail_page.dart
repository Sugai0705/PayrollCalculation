import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payroll_detail_controller.dart';

class PayrollDetailPage extends StatelessWidget {
  final String memberId;
  const PayrollDetailPage({required this.memberId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PayrollDetailController(memberId),
      child: Consumer<PayrollDetailController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return Scaffold(
              appBar: AppBar(title: Text('給料詳細')),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text('給料詳細')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('名前: ${controller.member?['name'] ?? ''}',
                      style: TextStyle(fontSize: 20)),
                  Text('時給: ${controller.member?['hourly_wage'] ?? ''}円',
                      style: TextStyle(fontSize: 18)),
                  Text('基本給: ${controller.baseSalary}円',
                      style: TextStyle(fontSize: 18)),
                  Text(
                      'インセンティブ合計: ${controller.incentiveTotal.toStringAsFixed(0)}円',
                      style: TextStyle(fontSize: 18)),
                  Text('総支給: ${controller.totalSalary.toStringAsFixed(0)}円',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('計算式:', style: TextStyle(fontSize: 18)),
                  ...controller.calculationDetails.map((d) => Text(d)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
