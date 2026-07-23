import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../database/database_helper.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'login_screen.dart';
import '../../utils/validators.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final _formKey = GlobalKey<FormState>();

final nameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();

bool isLoading = false;
class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  bool isLoading = false;

  

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    bool emailAlreadyExists =
        await DatabaseHelper.instance.emailExists(
      emailController.text.trim(),
    );

    if (emailAlreadyExists) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email already exists"),
        ),
      );

      return;
    }

    UserModel user = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    await DatabaseHelper.instance.insertUser(user);

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text(
            "Account created successfully.",
          ),
          actions: [

            TextButton(
              onPressed: () {

                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );

              },
              child: const Text("Login"),
            )

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF8FAFC),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),

          child:Form(
  key: _formKey,
  child: Column(
    children: [
                const SizedBox(height: 25),

                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        AppColors.primary.withOpacity(.15),
                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 45,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    "Create your MoneyMate account",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 35),
CustomTextField(
  controller: nameController,
  hintText: "Full Name",
  prefixIcon: Icons.person,
  validator: Validators.validateName,
),
                const SizedBox(height: 10),

              

               

                CustomTextField(
  controller: emailController,
  hintText: "Email",
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
  validator: Validators.validateEmail,
),

                const SizedBox(height: 10),

                CustomTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  prefixIcon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

             CustomTextField(
  controller: passwordController,
  hintText: "Password",
  prefixIcon: Icons.lock,
  obscureText: hidePassword,
  validator: Validators.validatePassword,
  suffixIcon: IconButton(
    onPressed: () {
      setState(() {
        hidePassword = !hidePassword;
      });
    },
    icon: Icon(
      hidePassword
          ? Icons.visibility_off
          : Icons.visibility,
    ),
  ),
),                                const SizedBox(height: 20),

              CustomTextField(
  controller: confirmPasswordController,
  hintText: "Confirm Password",
  prefixIcon: Icons.lock_outline,
  obscureText: hideConfirmPassword,
  textInputAction: TextInputAction.done,
  validator: (value) =>
      Validators.validateConfirmPassword(
    value,
    passwordController.text,
  ),
  suffixIcon: IconButton(
    onPressed: () {
      setState(() {
        hideConfirmPassword =
            !hideConfirmPassword;
      });
    },
    icon: Icon(
      hideConfirmPassword
          ? Icons.visibility_off
          : Icons.visibility,
    ),
  ),
),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      :CustomButton(
  text: "Create Account",
  onPressed: () {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    signUp();
  },
  height: 60,
  borderRadius: 18,
),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      "Already have an account? ",
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}