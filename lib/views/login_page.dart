import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/login_controller.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/views/admin_homepage.dart';
import 'package:health_link_plus/views/doctor_homepage.dart';
import 'package:health_link_plus/views/patient_homepage.dart';
import 'package:health_link_plus/views/sign_up_page.dart';
import 'package:health_link_plus/widgets/button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Inside the _LoginPageState class
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.blue.withValues(alpha: 0.1),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: screenWidth > 500 ? 400 : screenWidth * 0.9,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blueAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.blueAccent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                Obx(() {
                  return TextField(
                    controller: _passwordController,
                    obscureText: loginController.obsecurePassword.value,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.blueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.obsecurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.blueAccent,
                        ),
                        onPressed: () {
                          loginController.obsecurePassword.value =
                              !loginController.obsecurePassword.value;
                        },
                      ),
                    ),

                    onSubmitted: (value) {
                      loginController.login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    },
                  );
                }),
                const SizedBox(height: 25),

                // Login Button
                ButtonWidget(
                  text: 'Login',
                  isLoading: loginController.isLoading,
                  onPressed: () {
                    loginController.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 20),

                // Create Account Link
                GestureDetector(
                  onTap: () {
                    Get.to(SignUpPage());
                  },
                  child: const Text(
                    "Don’t have an account? Create one",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.blueAccent, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
