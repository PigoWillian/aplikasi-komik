import 'package:app_komik_manga/models/image_pick.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../models/textfield_email.dart';
import '../models/textfield_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController email;
  late TextEditingController password;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadAuth = context.watch<MyAuthProvider>();

    return Container(
      color: const Color.fromARGB(255, 29, 29, 29),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4 - 20,
                decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 5))
                    ]),
              ),
              Column(
                children: [
                  const Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height / 4 - 20,
                    decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.green,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, -5))
                        ]),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loadAuth.islogin ? "Login" : "Register ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.fontSize),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.green,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 3))
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!loadAuth.islogin) ImagePickWidget(),
                            TextfieldEmailWidget(controller: email),
                            const SizedBox(
                              height: 15,
                            ),
                            TextfieldPasswordWidget(controller: password),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  loadAuth.submit(_formKey, context);
                                },
                                child: Text(
                                    loadAuth.islogin ? "Login" : "Register"),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  loadAuth.islogin = !loadAuth.islogin;
                                });
                              },
                              child: Text(loadAuth.islogin
                                  ? "Create account"
                                  : "I already have an account"),
                            )
                          ],
                        ),
                      ),
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
}
