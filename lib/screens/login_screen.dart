import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:work_app/api/config.dart';
import 'dart:convert';
import 'package:work_app/components/my_button.dart';
import 'package:work_app/components/my_textfiled.dart';
import 'package:work_app/screens/user-map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = true; // Başlangıçta her zaman işaretli olacak

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkRememberMe(); // Uygulama açıldığında kullanıcıyı kontrol et
  }

  // Uygulama açıldığında token'ı kontrol eden fonksiyon
  Future<void> checkRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    if (token != null) {
      // Token varsa kullanıcı zaten giriş yapmıştır, doğrudan harita sayfasına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserLocation()),
      );
    }
  }

  // Kullanıcı giriş yaparken token kaydet
  Future<void> signUserIn() async {
    final email = emailController.text;
    final password = passwordController.text;

    final String apiUrl = Config.apiUrl + 'login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['user']['token'];

        // Token kontrolü
        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_token', token);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserLocation()),
          );
        }
      } else {
        final responseBody = json.decode(response.body);
        final error = responseBody['error'] ?? 'E-posta veya şifre yanlış';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('E-mail və ya şirfrə yanlışdır: $error')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/rslogo.png',
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome Work Time Application',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Enter Your Email Address',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Enter Your Password',
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() {
                              rememberMe = newValue ?? true; 
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    onTap: signUserIn,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
