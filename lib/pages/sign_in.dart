import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:obatku/components/stateful_widgets/large_button.dart';
import 'package:obatku/components/stateful_widgets/my_text_field.dart';
import 'package:obatku/pages/home_page.dart';

class SignIn extends StatefulWidget {
  final void Function()? onTap;

  const SignIn({super.key, required this.onTap});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool _obscureText = true;

  Future<void> loginuser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil Login')));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9381FF),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/Rectangle 171.png',
                fit: BoxFit.cover,
                height: 270,
                width: double.infinity,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'SIGN IN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // email
                  MyTextfield(
                    label: '',
                    icon: Icons.email_outlined,
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 24),
                  // Password
                  MyTextfield(
                    label: '',
                    icon: _obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: _obscureText,
                  ),
                  const SizedBox(height: 32),
                  // Sign In button
                  LargeButton(
                    text: 'Sign In',
                    onTap: loginuser,
                    color: Colors.white,
                    textColor: Colors.black,
                  ),

                  const SizedBox(height: 24),
                  // OR divider
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Sign Up button
                  LargeButton(
                    text: 'Sign Up',
                    onTap: widget.onTap,
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  // Bottom text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a member? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
