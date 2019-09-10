import "package:flutter/material.dart";
import "dart:io";

import "reminder.dart";
import "reauth.dart";
import "login_page.dart";

class ReminderPage extends StatefulWidget {
    final Reminder reminder;

    ReminderPage(this.reminder);

    @override
    ReminderPageState createState() => ReminderPageState();
}

class ReminderPageState extends State<ReminderPage> {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    Reminder reminder;

    TextEditingController name;
    TextEditingController description;

    @protected
    @mustCallSuper
    void initState() {
        this.reminder = widget.reminder;

        name = TextEditingController(text: this.reminder.name);
        description = TextEditingController(text: this.reminder.description);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text("Reminder"),
            ),
            body: Center(
                child:Column(
                    children: <Widget>[
                        Container(
                            child: TextField(
                                controller: name,
                                decoration: InputDecoration(
                                    labelText: "Name",
                                ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.80,
                        ),
                        Container(
                            child: TextField(
                                controller: description,
                                minLines: 3,
                                maxLines: 5,
                                decoration: InputDecoration(
                                    labelText: "Description",
                                ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.80,
                        ),
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save),
                onPressed: save,
            ),
        );
    }

    void save() async {
        this.reminder.name = name.text;
        this.reminder.description = description.text;

        var response = await this.reminder.update();

        // Switch the status code.
        switch (response.statusCode) {
            case HttpStatus.ok:
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Saved."),
                ));
                break;

            case HttpStatus.unauthorized:
                // Attempt to ReAuth.
                if (ReAuth.attempt(response.body)) {
                    // Successfully authorized, try again.
                    save();
                    break;
                }

                // Go to the login page.
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                );

                break;

            case HttpStatus.internalServerError:
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Couldn't save: internal server error."),
                ));
                break;
        }
    }
}