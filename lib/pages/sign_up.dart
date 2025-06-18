import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obatku/components/stateful_widgets/large_button.dart';
import 'package:obatku/components/stateful_widgets/my_text_field.dart';
import 'package:obatku/pages/home_page.dart';

class SignUp extends StatefulWidget {
  final void Function()? onTap;

  const SignUp({super.key, required this.onTap});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool _obscureText = true;

  Future<void> registeruser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      User? user = userCredential.user;

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil Register')));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Register gagal: ${e.message}')));
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
                'assets/images/Rectangle 172.png',
                fit: BoxFit.cover,
                height: 270,
                width: double.infinity,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'SIGN UP',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                  // Username
                  MyTextfield(
                    label: '',
                    icon: Icons.person_outline,
                    controller: usernameController,
                    hintText: 'Username',
                  ),
                  const SizedBox(height: 24),
                  // Email
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
                  // Sign Up button (utama)
                  LargeButton(
                    text: 'Sign Up',
                    onTap: registeruser,
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
                  const SizedBox(height: 20),
                  // Bottom text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign In",
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
