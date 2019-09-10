import "package:shared_preferences/shared_preferences.dart";

class Credentials {
    String auth, refresh;

    Credentials();

    Map<String, dynamic> toJson() =>
    {
        "Auth": this.auth,
        "Refresh": this.refresh,
    };

    void save() async {
        final prefs = await SharedPreferences.getInstance();

        prefs.setString("auth", this.auth);
        prefs.setString("refresh", this.refresh);
    }

    Future<bool> load() async {
        final prefs = await SharedPreferences.getInstance();
        
        this.auth = prefs.getString("auth") ?? "";
        this.refresh = prefs.getString("refresh") ?? "";

        if (this.auth == "" || this.refresh == "")
            return false;

        return true;
    }
}

Credentials GlobalCredentials;