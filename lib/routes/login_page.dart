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
  bool _rememberPwd = false;

  // 初始化API，回填已记住的账号密码
  @override
  void initState() {
    super.initState();
    _loadRememberedAccount();
  }

  void _loadRememberedAccount() async {
    final r = await Global.loadRememberedAccount();
    if (r.username.isNotEmpty) {
      _unameController.text = r.username;
      _pwdController.text = r.password;
      setState(() => _rememberPwd = true);
    }
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset('assets/images/logo.png', height: 72),
                      const SizedBox(height: 12),
                      // 应用标题
                      Text(
                        F.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _unameController,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          labelText: "用户名",
                          hintText: "请输入用户名",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        ),

                        // 校验用户名
                        validator: (v) {
                          return v == null||v.trim().isNotEmpty ? null :  "用户名不能为空";
                        },
                      ),

                      const SizedBox(height: 16,),

                      TextFormField(
                        controller: _pwdController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "密码",
                          hintText: "请输入密码",
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                      // 记住账号密码
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () =>
                              setState(() => _rememberPwd = !_rememberPwd),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _rememberPwd
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.blue,
                                  size: 22,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '记住账号密码',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _loginIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("登录",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      // 更新按钮预留位置
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
        // 业务码以响应体 code 为准（HTTP 200 时 body 仍可能是失败）
        final code = r.data is Map ? r.data["code"] : null;
        if(r.statusCode == 200 && code == 200){
          // 持久化登录凭证（同步内存 + 持久化 + 恢复 Cookie）
          await Global.saveAuth(
            r.data["token"] as String? ?? "",
            r.data["data"] as String? ?? "",
            r.data["ruoyiToken"] as String? ?? "",
          );

          var userInfo = await UserApi().getProfile();
          final infoCode = userInfo.data is Map ? userInfo.data["code"] : null;
          if(userInfo.statusCode == 200 && infoCode == 200){
            try {
              Global.profile = Profile.fromJson(userInfo.data['data']);
            } catch (e) {
              // 字段结构不匹配：保留登录态，首页信息区显示“未登录”，日志可查原始报文
              debugPrint('profile parse error: $e');
            }
            await Global.setLogin(true);
            // 按勾选状态决定是否记住账号密码
            if (_rememberPwd) {
              await Global.saveRememberedAccount(
                _unameController.text.trim(),
                _pwdController.text,
              );
            } else {
              await Global.clearRememberedAccount();
            }
          }else{
            // profile 拉取失败：撤销刚保存的凭证，避免脏数据
            await Global.clear();
            SmartDialog.dismiss();
            SmartDialog.showToast("获取用户信息失败，请检查网络");
            return;
          }
          SmartDialog.dismiss();
          // 异步跳转首页，mounted确保数据落地结束
          if (mounted) {
            GoRouter.of(context).goNamed("home");
          }
        }else{
          SmartDialog.dismiss();
          SmartDialog.showToast((r.data is Map ? (r.data["msg"] ?? "账号或密码错误") : "账号或密码错误").toString());
        }
      }on DioException catch(e){
        SmartDialog.dismiss();
        SmartDialog.showToast(e.message ?? e.toString());
      } catch (e) {
        SmartDialog.dismiss();
        SmartDialog.showToast("登录异常：$e");
      }
    }
  }
}