import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:email_validator/email_validator.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "dart:io";

import "credentials.dart";
import "register_page.dart";
import "list_page.dart";

@JsonSerializable()
class LoginRequest {
    String email, password;

    LoginRequest(email, password) {
        this.email = email;
        this.password = password;
    }

    Map<String, dynamic> toJson() =>
    {
        "Email": this.email,
        "Password": this.password,
    };
}

class LoginResponse {
    Credentials credentials;
}

class LoginPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => LoginPageState();
}

bool authChecked = false;

class LoginPageState extends State<LoginPage> {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    @protected
    @mustCallSuper
    void initState() {
        if (!authChecked) {
            authChecked = true;
            checkAuth();
        }
    }

    void checkAuth() async {
        GlobalCredentials = Credentials();

        if (await GlobalCredentials.load()) {
            // Go to the list page.
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ListPage()),
            );
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text("Log in"),
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
                                child: Text("Log in"),
                                onPressed: () => login(context),
                            ),
                        ),
                        Container(
                            child: FlatButton(
                                child: Text("Register"),
                                onPressed: () => register(context),
                            ),
                        ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                ),
            ),
        );
    }

    static const String url = "https://europe-west1-froogo-reminder-api.cloudfunctions.net/login";
    static const Map<String, String> headers = {"Content-type": "application/json"};

    void login(context) async {
        // Check if the email is valid.
        if (!EmailValidator.validate(email.text)) {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Your email is invalid."),
            ));

            return;
        }

        // Check if the password is valid.
        if (password.text.length < 1) {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Your password is invalid."),
            ));

            return;
        }

        // Encode the login request to JSON.
        String inputJSON = json.encode(LoginRequest(
            email.text,
            password.text,
        ));

        // Send the JSON request.
        http.Response response = await http.post(
            url,
            headers: headers,
            body: inputJSON,
        );

        // Switch the status code.
        switch (response.statusCode) {
            case HttpStatus.ok:
                // Successful login.
                // Decode the response.
                Map<String, dynamic> body = json.decode(response.body);
                // Set the global credentials value to our new credentials.
                Credentials credentials = Credentials.fromJSON(body);

                // Save the credentials.
                credentials.save();

                // Go to the list page.
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ListPage()),
                );
                break;

            case HttpStatus.badRequest:
                // Invalid credentials.
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Invalid login."),
                ));
                break;

            case HttpStatus.internalServerError:
                // Internal server error.
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Internal server error."),
                ));
                break;
        }
    }

    void register(context) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage())
        );
    }
}