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
      builder: (context, child) {
        // Providerが有効なcontextでfetchDetail()を呼ぶ
        final controller =
            Provider.of<MembersDetailController>(context, listen: false);
        controller.fetchDetail();

        return Consumer<MembersDetailController>(
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
                          Text(
                              '勤務時間合計: ${controller.getTotalWorkHours().toStringAsFixed(1)}時間',
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 16),
                          Text('勤怠履歴:', style: TextStyle(fontSize: 18)),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.workTimes.length,
                              itemBuilder: (context, index) {
                                final wt = controller.workTimes[index];
                                final date = wt['date'] ?? '';
                                final hours = wt['hours'] ?? '';
                                final wage = wt['hourly_wage'] ?? '';
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    '日付: $date / 勤務時間: $hours時間',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
