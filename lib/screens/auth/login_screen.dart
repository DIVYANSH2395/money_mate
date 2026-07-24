import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../database/database_helper.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';
import '../../utils/validators.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

bool isPasswordHidden = true;
bool isLoading = false;
  bool isPasswordHidden = true;
final _formKey = GlobalKey<FormState>();

bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
Future<void> login() async {

 {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter email"),
      ),
    );
    return;
  }

   {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter password"),
      ),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  UserModel? user = await DatabaseHelper.instance.loginUser(
    emailController.text.trim(),
    passwordController.text.trim(),
  );

  setState(() {
    isLoading = false;
  });

  if (user == null) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invalid Email or Password"),
      ),
    );

    return;
  }

  SharedPreferences prefs =
      await SharedPreferences.getInstance();

  await prefs.setBool("isLoggedIn", true);
  await prefs.setString("userName", user.name);
  await prefs.setString("userEmail", user.email);

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    ),
  );

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
child: Form(
  key: _formKey,
  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.primary.withOpacity(.15),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                    size: 45,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Center(
                child: Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  "Login to continue using MoneyMate",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

             CustomTextField(
  hintText: "Enter your email",
  prefixIcon: Icons.email_outlined,
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  validator: Validators.validateEmail,
),

              const SizedBox(height: 20),

              const Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

CustomTextField(
  validator: Validators.validatePassword,
  textInputAction: TextInputAction.done,
                  hintText: "Enter your password",
                prefixIcon: Icons.lock_outline,
                controller: passwordController,
                obscureText: isPasswordHidden,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                  style: TextButton.styleFrom(
  foregroundColor: AppColors.primary,
)
                ),
              ),

              const SizedBox(height: 15),

            isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : CustomButton(
      if (!_formKey.currentState!.validate()) {
  return;
}
        text: "Login",
        onPressed: login,
        height: 60,
        borderRadius: 18,
      ),
              const SizedBox(height: 30),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, size: 30),
                  label: const Text(
                    "Continue with Google",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SignupScreen(),
    ),
  );
},
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}