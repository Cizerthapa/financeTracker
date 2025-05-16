import 'package:finance_track/screens/watch_screens/watchwearos_homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class Authorize extends StatefulWidget {

  const Authorize({super.key});

  @override
  State<Authorize> createState() => _AuthorizeState();
}

class _AuthorizeState extends State<Authorize> {

  late bool isAppOpen = false;

  late WatchConnectivity _watchConnectivity = WatchConnectivity();
  late String messages = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize _watchConnectivity here to ensure it is only initialized once
    _watchConnectivity = WatchConnectivity();

    // Listen to messages from the watch after initialization
    _watchConnectivity.messageStream.listen((message) {
      setState(() {
      if(message["auth_message"].toString().isNotEmpty)
        {
          messages = "User Not Logged In";
        }
      });
      if (message["Accessed"] == true && message["uid"].toString().isNotEmpty) {
        print(message["uid"].toString());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WatchwearosHomescreen()),
        );
      }
      else
      {
        print("empty!");
      }
    });
  }

  void isAuthorized() async {
        if (await _watchConnectivity.isReachable)
        {
          try {
            await _watchConnectivity.sendMessage({
              "UserSession": true,
            });
            print("Message sent to Mobile O");
          }
          catch (e)
          {
            print("Failed to send message: $e");
            _showWarning("Phone is reachable, but app is not open.");
          }
        }
        else
        {
          print("Mobile OS device is not reachable");
          _showWarning("Phone not reachable");
        }
  }
  void _showWarning(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Warning",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D3343),
                /*    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),*/
                  ),
                  onPressed: ()
                  {
                    isAuthorized();
                  },
                  child: Text(
                      "Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),

            Text(messages,
            style: TextStyle(
              color: Colors.black,
              fontSize: 11
            ),)
          ],
        )
      ),

    );
  }


}
