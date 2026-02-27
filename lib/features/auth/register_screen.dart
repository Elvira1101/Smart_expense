import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 20),


                Image.asset(
                  "assets/images/SmartExpenseLogo.png",
                  width: MediaQuery.of(context).size.width * 0.48,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Inscription",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 25),

                /// Card Form
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // plus opaque pour ressembler à l'image
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2), // plus opaque pour ressembler à l'image
                    ),
                    boxShadow: [

                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Name
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInput(
                        hint: "ex : elvira ngahane",
                        onSaved: (value) => name = value!,
                        validator: (value) => value!.isEmpty ? "Enter your name" : null,
                      ),

                      const SizedBox(height: 20),

                      // Email
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInput(
                        hint: "ex: elvirangahaneket@gmail.com",
                        onSaved: (value) => email = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your email";
                          }

                          if (!value.endsWith("@gmail.com")) {
                            return "Email must end with @gmail.com";
                          }

                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                            return "Invalid Gmail format";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInput(
                        hint: "••••••••",
                        obscure: true,
                        onSaved: (value) => password = value!,
                        validator: (value) =>
                        value!.length < 6 ? "Min 6 characters" : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// Submit button
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pushReplacementNamed(context, '/dashboard');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Inscription réussie pour $name',
                            ),
                          ),
                        );

                        print("Name: $name");
                        print("Email: $email");
                        print("Password: $password");
                      }
                    },
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(
                        color: Colors.white,      // couleur du texte
                        fontSize: 16,             // taille de police
                        fontWeight: FontWeight.bold, // gras

                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String hint,
    bool obscure = false,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      obscureText: obscure,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
