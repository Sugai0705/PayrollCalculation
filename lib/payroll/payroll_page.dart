import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payroll_controller.dart';
import 'package:go_router/go_router.dart';

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
              itemCount: controller.members.length,
              itemBuilder: (context, index) {
                final member = controller.members[index];
                final memberId = member['id'];
                final salary = controller.payrolls[memberId] ?? 0;
                return ListTile(
                  title: Text(member['name'] ?? ''),
                  subtitle: Text('給料: ${salary.toStringAsFixed(0)}円'),
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
