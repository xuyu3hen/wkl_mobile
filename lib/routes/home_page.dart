import 'package:wkl_mobile/index.dart';

/// 菜单分类：左侧菜单项 + 右侧功能入口列表
class MenuCategory {
  final String name;
  final IconData icon;
  final List<MenuEntry> entries;

  const MenuCategory({
    required this.name,
    required this.icon,
    required this.entries,
  });
}

/// 功能入口
class MenuEntry {
  final String name;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const MenuEntry({
    required this.name,
    required this.icon,
    this.color,
    this.onTap,
  });
}

class HomePage extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMenuIndex = 0;

  // 左侧菜单分类（控制右侧功能入口）
  final List<MenuCategory> _categories = [
    MenuCategory(
      name: '工单',
      icon: Icons.work_outline,
      entries: [
        MenuEntry(name: '任务', icon: Icons.assignment_outlined, color: Colors.blue, onTap: () {}),
        MenuEntry(name: '审批', icon: Icons.assignment_turned_in_outlined, color: Colors.green, onTap: () {}),
        MenuEntry(name: '日程', icon: Icons.calendar_today_outlined, color: Colors.orange, onTap: () {}),
        MenuEntry(name: '邮件', icon: Icons.mail_outline, color: Colors.redAccent, onTap: () {}),
        MenuEntry(name: '消息', icon: Icons.message_outlined, color: Colors.purple, onTap: () {}),
        MenuEntry(name: '公告', icon: Icons.campaign_outlined, color: Colors.teal, onTap: () {}),
      ],
    ),
    MenuCategory(
      name: '物料',
      icon: Icons.business_center_outlined,
      entries: [
        MenuEntry(name: '核验', icon: Icons.receipt_long_outlined, color: Colors.blue, onTap: () => Navigator.pushNamed(HomePage.navigatorKey.currentContext!, 'mainverify')),
        // MenuEntry(name: '订单', icon: Icons.receipt_long_outlined, color: Colors.green, onTap: () {}),
        // MenuEntry(name: '产品', icon: Icons.inventory_2_outlined, color: Colors.orange, onTap: () {}),
        // MenuEntry(name: '合同', icon: Icons.description_outlined, color: Colors.redAccent, onTap: () {}),
      ],
    ),
    MenuCategory(
      name: '报表',
      icon: Icons.bar_chart_outlined,
      entries: [
        MenuEntry(name: '销售', icon: Icons.trending_up, color: Colors.blue, onTap: () {}),
        MenuEntry(name: '财务', icon: Icons.account_balance_outlined, color: Colors.green, onTap: () {}),
        MenuEntry(name: '库存', icon: Icons.warehouse_outlined, color: Colors.orange, onTap: () {}),
      ],
    ),
    MenuCategory(
      name: '系统',
      icon: Icons.settings_outlined,
      entries: [
        MenuEntry(name: '用户', icon: Icons.manage_accounts_outlined, color: Colors.blue, onTap: () {}),
        MenuEntry(name: '权限', icon: Icons.security_outlined, color: Colors.green, onTap: () {}),
        MenuEntry(name: '日志', icon: Icons.article_outlined, color: Colors.orange, onTap: () {}),
        MenuEntry(name: '设置', icon: Icons.settings, color: Colors.redAccent, onTap: () {}),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // 右上背景图
            Positioned(
              right: 0,
              top: 0,
              child: Image.asset(
                'assets/images/page_title.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            // 右下背景图
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset('assets/images/login_bg.png',width: MediaQuery.of(context).size.width,),
            ),
            // 前景内容
            Column(
              children: [
                _buildUserInfoHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 顶部 300px 用户信息展示
  Widget _buildUserInfoHeader() {
    final profile = Global.profile;
    final user = profile?.user;
    final org = profile?.org;
    final roles = profile?.roles ?? [];

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 头像
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 用户名
                    Text(
                      Global.profile?.user?.userName ?? '未登录',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 登录名
                    if (user?.userLoginName != null)
                      Text(
                        '工号：${user!.userLoginName}',
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    const SizedBox(height: 4),
                    // 组织
                    if (org?.orgName != null)
                      Text(
                        '班组：${org!.orgName}',
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    const SizedBox(height: 8),
                    // 角色
                    if (roles.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: roles
                            .where((r) => r.roleName != null)
                            .map((r) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    r.roleName!,
                                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                                  ),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 下方：左侧菜单 + 右侧功能入口
  Widget _buildBody() {
    return Row(
      children: [
        // 左侧竖直菜单栏
        Container(
          width: 80,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.06),
            border: Border(right: BorderSide(color: Colors.blue.withOpacity(0.15))),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0),
            itemCount: _categories.length,
            itemBuilder: (context, index) => _buildMenuItem(index),
          ),
        ),
        // 右侧功能入口
        Expanded(child: _buildEntriesGrid()),
      ],
    );
  }

  /// 左侧菜单项
  Widget _buildMenuItem(int index) {
    final category = _categories[index];
    final selected = index == _selectedMenuIndex;
    return InkWell(
      onTap: () => setState(() => _selectedMenuIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: selected ? Colors.blue : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 24,
              color: selected ? Colors.white : Colors.blue,
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: TextStyle(
                color: selected ? Colors.white : Colors.blue,
                fontSize: 14,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 右侧功能入口：一行三个，超出自动换行
  Widget _buildEntriesGrid() {
    final entries = _categories[_selectedMenuIndex].entries;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildEntryItem(entry);
      },
    );
  }

  /// 单个功能入口（正方形）
  Widget _buildEntryItem(MenuEntry entry) {
    return InkWell(
      onTap: entry.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (entry.color ?? Colors.blue).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                entry.icon,
                size: 28,
                color: entry.color ?? Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              entry.name,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
