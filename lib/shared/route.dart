import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroll_calculation/shared/global_navigation.dart';
import '../login/login_page.dart';
import '../home/home_page.dart';
import '../members/members_page.dart';
import '../payroll/payroll_detail_page.dart';
import '../payroll/payroll_page.dart';
import '../sales/sales_page.dart';
import '../logic/logic_page.dart';
import '../members/members_detail_page.dart';

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
          bottomNavigationBar: GlobalNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(index, initialLocation: true);
            },
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
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  builder: (context, state) {
                    final memberId = state.pathParameters['id'];
                    return MembersDetailPage(memberId: memberId!);
                  },
                ),
              ],
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
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  builder: (context, state) {
                    final memberId = state.pathParameters['id']!;
                    return PayrollDetailPage(memberId: memberId);
                  },
                ),
              ],
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
