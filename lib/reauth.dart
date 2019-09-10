import "dart:convert";

import "credentials.dart";

class ReAuthResponse {
    Credentials credentials;

    ReAuthResponse.fromJSON(Map<String, dynamic> json) {
        this.credentials.auth = json["Credentials"]["Auth"];
        this.credentials.refresh = json["Credentials"]["Refresh"];
    }
}

class ReAuth {
    static bool attempt(body) {
        var decoded = json.decode(body);
        var response = ReAuthResponse.fromJSON(decoded);

        GlobalCredentials = response.credentials;
        GlobalCredentials.save();

        if (GlobalCredentials.auth == "" || GlobalCredentials.refresh == "") {
            return false;
        }

        return true;
    }
}