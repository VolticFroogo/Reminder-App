import "dart:convert";
import "package:http/http.dart" as http;
import "package:json_annotation/json_annotation.dart";

import "credentials.dart";

@JsonSerializable()
class UpdateRequest {
    Reminder reminder;
    Credentials credentials;

    UpdateRequest(this.reminder, this.credentials);

    Map<String, dynamic> toJson() =>
    {
        "Reminder": this.reminder,
        "Credentials": this.credentials,
    };
}

class Reminder {
    String name, description, key;
    int creation, modification, activation;

    Reminder();

    Map<String, dynamic> toJson() =>
    {
        "Name": this.name,
        "Description": this.description,
        "Key": this.key,
        "Creation": this.creation,
        "Modification": this.modification,
        "Activation": this.activation,
    };

    Reminder.fromJSON(Map<String, dynamic> json) {
        this.name = json["Name"];
        this.description = json["Description"];
        this.key = json["Key"];
        this.creation = json["Creation"];
        this.modification = json["Modification"];
        this.activation = json["Activation"];
    }

    static const Map<String, String> headers = {"Content-type": "application/json"};
    static const String updateURL = "https://europe-west1-froogo-reminder-api.cloudfunctions.net/update";

    Future<http.Response> update() async {
        // Encode the login request to JSON.
        var inputJSON = json.encode(UpdateRequest(
            this,
            GlobalCredentials,
        ));

        // Send the JSON request.
        var response = await http.post(
            updateURL,
            headers: headers,
            body: inputJSON,
        );

        return response;
    }

    int delete() {
        return 200;
    }
}