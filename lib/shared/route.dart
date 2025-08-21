import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login/login_page.dart';
import 'home/home_page.dart';
import 'members/members_page.dart';
import 'sales/sales_page.dart';
import 'payroll/payroll_page.dart';
import 'logic/logic_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: navigationShell.goBranch,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'メンバー'),
              BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: '売上'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: '給料'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ロジック'),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/members',
              builder: (context, state) => MembersPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sales',
              builder: (context, state) => SalesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/payroll',
              builder: (context, state) => PayrollPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/logic',
              builder: (context, state) => LogicPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);