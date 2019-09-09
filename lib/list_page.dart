import "package:flutter/material.dart";

import "new_page.dart";

class ListPage extends StatefulWidget {
    @override
    ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Reminder List"),
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
            body: Center(
                child: Text("Blah, blah, blah."),
            ),
        );
    }
}