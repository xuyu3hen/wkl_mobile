import '../index.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 路由列表，待全路由迁移
class RouterList{
  get router => _router;
  final _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home', // Optional, add name to your routes. Allows you navigate by name instead of path
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'mainverify',
        path: '/mainverify',
        builder: (context, state) => const MainVerifyPage(),
      ),
    ],
    // 重定向到登录页面 login页面存在异步数据延迟；
    redirect: (context, state) {
      if(state.fullPath == '/'){
        if(!Global.isLogin){
          // 未登录，跳转到登录页
          return '/login';
        }
        return null;
      }
      return null;
    },
    // errorBuilder: (context, state) {
      
    // },
  );

}