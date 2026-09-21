import 'package:wkl_mobile/index.dart';
import 'package:wkl_mobile/zjc_module/widgets/zjc_top_tabbar.dart';

class MainVerifyPage extends StatefulWidget {
  const MainVerifyPage({super.key});

  @override
  State<MainVerifyPage> createState() => _MainVerifyPageState();
}
class _MainVerifyPageState extends State<MainVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return const ZjcTopTabBar(
      bgColor: Colors.transparent,
      title: '核验列表',
      tabModelArr: [
        ZjcTopTabBarModel(title: '待核验', widget: PurchaseUnVerified()),
        ZjcTopTabBarModel(title: '已核验', widget: PurchaseVerified()),
      ],
      showCenterLine: true,
      isScrollable: false,
      appBarColor:Colors.lightBlue,
    );
  }
}
