import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic_controller.dart';

class LogicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logicInputController = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => LogicController(),
      child: Consumer<LogicController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: Text('給料計算ロジック')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('現在のロジック: ${controller.currentLogic}'),
                  TextField(
                    controller: logicInputController,
                    decoration: InputDecoration(labelText: '新しいロジックを入力'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.updateLogic(logicInputController.text);
                      logicInputController.clear();
                    },
                    child: Text('ロジックを更新'),
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