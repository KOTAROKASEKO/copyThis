static Future<void> sendPushMessage(String token, String title, String body) async {

    //MODIFY HERE FOR YOUR FILE ACCESS
    final jsonString = await rootBundle.loadString('assets/firebase-adminsdk.json');
    final jsonKey = jsonDecode(jsonString);
    final credentials = ServiceAccountCredentials.fromJson(jsonKey);
    // Define the required Google API scopes for FCM
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Create an authenticated client using OAuth 2.0
    AuthClient authClient = await clientViaServiceAccount(credentials, scopes);

    // Firebase Cloud Messaging HTTP v1 URL (replace YOUR_PROJECT_ID)
    const url = 'https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send';

    // Create the payload for the notification
    final payload = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'message': 'There is an update in reservation!'
        },
      },
    };

    // Send the HTTP POST request
    final response = await authClient.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    // Handle the response
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }

    // Close the authenticated client
    authClient.close();
  }
