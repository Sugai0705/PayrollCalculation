import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'members_controller.dart';
import 'package:go_router/go_router.dart';

class MembersPage extends StatefulWidget {
  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  bool showSearch = false;
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MembersController(),
      child: Consumer<MembersController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('メンバー一覧'),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      showSearch = !showSearch;
                      if (!showSearch) {
                        searchController.clear();
                        controller.searchMembers('');
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: () {
                    setState(() {
                      controller.sortByPosition();
                    });
                  },
                ),
              ],
              bottom: showSearch
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(56.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            controller.searchMembers(value);
                          },
                          decoration: InputDecoration(
                            hintText: '名前で検索',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            body: controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (controller.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(controller.errorMessage!,
                              style: TextStyle(color: Colors.red)),
                        ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await controller.fetchMembers();
                          },
                          child: ListView.builder(
                            itemCount: controller.members.length,
                            itemBuilder: (context, index) {
                              final member = controller.members[index];
                              return ListTile(
                                title: Text(member['name'] ?? ''),
                                subtitle: Text(
                                    '役職: ${MembersController.getPositionLabel(member['position'])}'),
                                onTap: () {
                                  context.go('/members/detail/${member['id']}');
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/members/add');
                            },
                            child: Text('メンバー追加'),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
