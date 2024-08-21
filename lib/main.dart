import 'package:flutter/material.dart';
import 'package:flutter_login/models/usermodel.dart';
import 'package:flutter_login/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserModel userModel;

  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void _submit(String email, String password) {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFunction(email, password);
    _formKey.currentState!.save();
  }

  bool hasLogin = false;
  loginFunction(String email, String passWord) {
    setState(() {
      hasLogin = userModel.users.any((element) =>
          element.emailId == email && element.password == passWord);
      if (hasLogin) {
        int index = userModel.users.indexWhere((element) =>
            element.emailId == email && element.password == passWord);

        loggedUser = userModel.users[index];
      }
    });
  }

  late final SharedPreferences prefs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initShared();
  }

  initShared() async {
    prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      userModel = userModelFromJson(userData);
    } else {
      userModel = UserModel(users: []);
    }
  }

  late User loggedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: hasLogin
            ? Text(loggedUser.username)
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (value) {
                        //Validator
                      },
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                    ),
                    //box styling
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                    //text input
                    TextFormField(
                      controller: passWordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (value) {},
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid password!';
                        } else if (value.length < 8) {
                          return "Password must have least 8 characters";
                        }
                        return null;
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () async {
                            setState(() {
                               String? userData = prefs.getString('userData');
                            if (userData != null) {
                              userModel = userModelFromJson(userData);
                            } else {
                              userModel = UserModel(users: []);
                            }
                            });
                           
                            _submit(
                                emailController.text, passWordController.text);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text("Login"),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                        },
                        child: const Text("Click here for new user!"))
                  ],
                ),
              ),
      ),
    );
  }
}
