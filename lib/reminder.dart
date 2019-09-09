import "credentials.dart";

class Reminder {
    String name, description, key;
    int creation, modification, activation;

    int delete() {
        return 200;
    }
}