import 'package:flutter/material.dart';
import 'login_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: Text('ログイン')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(labelText: 'メールアドレス'),
                  ),
                  TextField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(labelText: 'パスワード'),
                    obscureText: true,
                  ),
                  if (controller.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        controller.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  await controller.login();
                                  if (controller.errorMessage == null) {
                                    // ログイン成功時の画面遷移
                                    GoRouter.of(context).go('/home');
                                  }
                                },
                          child: Text('ログイン'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  await controller.signUp();
                                  if (controller.errorMessage == null) {
                                    // 新規登録成功時の画面遷移
                                    GoRouter.of(context).go('/home');
                                  }
                                },
                          child: Text('新規登録'),
                        ),
                      ),
                    ],
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