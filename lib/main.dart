import "package:flutter/material.dart";

import "credentials.dart";
import "list_page.dart";
import "login_page.dart";

void main() {
    runApp(MaterialApp(
       title: "Reminder",
       home: LoginPage(),
    ));
}