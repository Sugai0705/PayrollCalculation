import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Consumer<HomeController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('ホーム'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.welcomeMessage,
                    style: TextStyle(fontSize: 20),
                  ),
                  // 売り上げのTOP3をランキング形式で表示
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.getTopSales().length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(controller.getTopSales()[index]),
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