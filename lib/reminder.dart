import "credentials.dart";

class Reminder {
    String name, description, key;
    int creation, modification, activation;

    Reminder.fromJSON(Map<String, dynamic> json) {
        this.name = json["Name"];
        this.description = json["Description"];
        this.key = json["Key"];
        this.creation = json["Creation"];
        this.modification = json["Modification"];
        this.activation = json["Activation"];
    }

    int delete() {
        return 200;
    }
}