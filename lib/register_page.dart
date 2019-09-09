import "package:flutter/material.dart";

class RegisterPage extends StatelessWidget {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Register"),
            ),
            body: Center(
                child: Column(
                    children: <Widget>[
                        Container(
                            child: TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: "Email",
                                ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: 70.0,
                        ),
                        Container(
                            child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: 80.0,
                        ),
                        Container(
                            child: RaisedButton(
                                child: Text("Register"),
                                onPressed: () => register(context),
                            ),
                        ),
                        Container(
                            child: FlatButton(
                                child: Text("Log in"),
                                onPressed: () => login(context),
                            ),
                        ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                ),
            ),
        );
    }

    void register(context) {
        // TODO: Add registration code.
    }

    void login(context) {
        Navigator.pop(context);
    }
}