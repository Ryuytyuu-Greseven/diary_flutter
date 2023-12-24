import 'package:http/http.dart' as http;

class LoginService {
  Future<void> fetchData() async {
    try {
      // Make a GET request
      final response =
          await http.post(Uri.parse('https://api.example.com/data'));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body (JSON, XML, etc.)
        print('Response body: ${response.body}');
      } else {
        // Handle error scenarios
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
    }
  }
}
