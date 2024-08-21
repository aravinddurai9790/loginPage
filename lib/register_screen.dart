import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/models/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    addUser();
  }

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  void addUser() {
    User user = User(
        username: userNameController.text,
        emailId: emailController.text,
        password: passWordController.text);
    userModel.users.add(user);
    prefs.remove("userData");
    prefs.setString("userData", userModelToJson(userModel));
    Navigator.pop(context);
  }

  late final SharedPreferences prefs;
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    initShared();
  }

  void initShared() async {
    prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      userModel = userModelFromJson(userData);
    } else {
      userModel = UserModel(users: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Register Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Username
                TextFormField(
                  controller: userNameController,
                  decoration: const InputDecoration(labelText: "Username"),
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a username!';
                    }
                    return null;
                  },
                ),
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
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    } else {
                      if (!regex.hasMatch(value)) {
                        return 'Enter valid password';
                      } else {
                        return null;
                      }
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'The password must have least one upper case,least one lower case,least one digit,least one Special character and 8 characters in length',
                    style: TextStyle(fontSize: 8),
                  ),
                ),

                InkWell(
                    onTap: () {
                      _submit();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text("Register"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
