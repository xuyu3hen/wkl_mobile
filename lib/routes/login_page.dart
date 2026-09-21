import 'package:wkl_mobile/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // 初始化API
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/login_bg.png'),
            alignment: Alignment.bottomRight,
          ),
        ),
        child:Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/page_title.png'),
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _unameController,
                      decoration: const InputDecoration(
                        labelText: "用户名",
                        hintText: "用户名",
                        prefixIcon: Icon(Icons.person),
                      ),

                      // 校验用户名
                      validator: (v) {
                        return v == null||v.trim().isNotEmpty ? null :  "用户名不能为空";
                      },
                    ),

                    const SizedBox(height: 10,),

                    TextFormField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                        labelText: "密码",
                        hintText: "密码",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: (){
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      // 密码是否显示
                      obscureText: !_isPasswordVisible,
                      // 校验密码
                      validator: (v) {
                        return v == null||v.trim().isNotEmpty ? null :  "密码不能为空";
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25,left: 30,right: 30),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.expand(
                          height: 55,
                        ),
                        child: ElevatedButton(
                          onPressed: _loginIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text("登录",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                    // 更新按钮预留位置
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  // 登录
  void _loginIn() async {
    if(_formKey.currentState!.validate()){
      SmartDialog.showLoading();
      try{
        var r = await UserApi().login(
          queryParameters: {
            "username": _unameController.text,
            "password": _pwdController.text,
          }
        );
        if(r.statusCode == 200){
          // 持久化登录凭证（同步内存 + 持久化 + 恢复 Cookie）
          await Global.saveAuth(
            r.data["token"] as String,
            r.data["data"] as String,
          );

          var userInfo = await UserApi().getProfile();
          if(userInfo.statusCode == 200){
            Global.profile = Profile.fromJson(userInfo.data['data']);
            await Global.setLogin(true);
          }else{
            // profile 拉取失败：撤销刚保存的凭证，避免脏数据
            await Global.clear();
            SmartDialog.dismiss();
            SmartDialog.showToast(userInfo.data["获取用户信息失败，请检查网络"]);
            return;
          }
          SmartDialog.dismiss();
          // 异步跳转首页，mounted确保数据落地结束
          if (mounted) {
            GoRouter.of(context).goNamed("home");
          }
        }else{
          SmartDialog.dismiss();
          SmartDialog.showToast(r.data["账号或密码错误"]);
        }
      }on DioException catch(e){
        SmartDialog.dismiss();
        SmartDialog.showToast(e.toString());
      }
    }
  }
}