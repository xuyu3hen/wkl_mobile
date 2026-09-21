import 'index.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: F.title,
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: RouterList().router,
      builder: FlutterSmartDialog.init(),
    );
  }

  // Widget _flavorBanner({required Widget child, bool show = true}) => show
  //     ? Banner(
  //         location: BannerLocation.topStart,
  //         message: F.name,
  //         color: Colors.green.withAlpha(150),
  //         textStyle: TextStyle(
  //           fontWeight: FontWeight.w700,
  //           fontSize: 12.0,
  //           letterSpacing: 1.0,
  //         ),
  //         textDirection: TextDirection.ltr,
  //         child: child,
  //       )
  //     : Container(child: child);
}
