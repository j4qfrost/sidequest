import 'package:atproto/atproto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce/hive.dart';
import 'package:sidequest/screens/home.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'login';

  const LoginScreen({super.key, required this.box});

  final Box box;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _handleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Function to handle the login logic (implemented in the next step)
  void _handleLogin(BuildContext context) async {
    _isLoading = true;
    // Create session with your credentials
    final session = await createSession(
      identifier: _handleController.text, // Your handle or email
      password: _passwordController.text, // App password recommended
      service: dotenv.env['SERVICE_DOMAIN'],
    );

    widget.box.put('session', session.data);
    _isLoading = false;

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => HomeScreen(box: widget.box),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluesky Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _handleController,
              decoration: InputDecoration(labelText: 'Handle or Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true, // This hides the input
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _handleLogin(context), // Disable button while loading
              child: _isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize:
                          MainAxisSize.min, // Keep the button size small
                      children: const [
                        Text('Loading...', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    )
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
