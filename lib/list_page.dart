import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "dart:io";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "credentials.dart";
import "reauth.dart";
import "login_page.dart";
import "reminder.dart";
import "new_page.dart";

@JsonSerializable()
class GetRequest {
    Credentials credentials;

    GetRequest(Credentials credentials) {
        this.credentials = credentials;
    }

    Map<String, dynamic> toJson() =>
    {
        "Credentials": this.credentials,
    };
}

class GetResponse {
    List<Reminder> reminders;

    GetResponse.fromJSON(Map<String, dynamic> json) {
        // Create a new list of reminders.
        reminders = List<Reminder>();

        // Iterate through each reminder.
        json["Reminders"].forEach((reminderJSON) {
            // Decode it and add it to the list.
            var reminder = Reminder.fromJSON(reminderJSON);
            this.reminders.add(reminder);
        });
    }
}

class ListPage extends StatefulWidget {
    @override
    ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    RefreshController refreshController = RefreshController(
        initialRefresh: true,
    );

    static const String url = "https://europe-west1-froogo-reminder-api.cloudfunctions.net/get";
    static const Map<String, String> headers = {"Content-type": "application/json"};

    List<Reminder> reminders = List<Reminder>();

    void refresh() async {
        // Encode the login request to JSON.
        var inputJSON = json.encode(GetRequest(
            GlobalCredentials,
        ));

        // Send the JSON request.
        var response = await http.post(
            url,
            headers: headers,
            body: inputJSON,
        );

        // Switch the status code.
        switch (response.statusCode) {
            case HttpStatus.ok:
                // Decode the response.
                var body = json.decode(response.body);
                var getResponse = GetResponse.fromJSON(body);

                // Set the new reminders.
                setState(() {
                    reminders = getResponse.reminders;
                });

                // Tell the refresh controller that the refresh has completed.
                refreshController.refreshCompleted();

                break;

            case HttpStatus.unauthorized:
                // Attempt to ReAuth.
                if (ReAuth.attempt(response.body)) {
                    // Successfully authorized, try again.
                    refresh();
                    break;
                }

                // Failed at authorizing.
                refreshController.refreshFailed();

                // Go to the login page.
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                );

                break;

            case HttpStatus.internalServerError:
                // Failed at getting reminders.
                refreshController.refreshFailed();

                // Show internal server error.
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Couldn't load reminders: internal server error."),
                ));
                break;
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text("Reminders"),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NewPage())
                            );
                        },
                    )
                ],
            ),
            body: SmartRefresher(
                enablePullDown: true,
                controller: refreshController,
                onRefresh: refresh,
                child: Column(
                    children: reminders.map((reminder) =>
                        ListTile(
                            title: Text(reminder.name),
                            subtitle: Text(reminder.description),
                        ),
                    ).toList(),
                ),
            ),
        );
    }
}