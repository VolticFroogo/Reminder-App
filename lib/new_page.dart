import "package:flutter/material.dart";

class NewPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("New Reminder"),
            ),
            body: Center(
                child: Text("New reminder stuff."),
            ),
        );
    }
}