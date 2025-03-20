import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:giccenroquezon/components/appbar_login.dart';
import 'package:giccenroquezon/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //------------------------------------------------------------------------//
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sample admin credentials.
  final String adminUsername = "admin";
  final String adminPassword = "admin123";

  bool _isLoading = false;
  bool _obscurePassword = true; // Controls show/hide password.

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic dimensions for the card based on the screen size.

    final InputDecoration inputDecoration = InputDecoration(
      labelStyle: const TextStyle(
        color: Colors.white60,
        fontFamily: 'Gilroy',
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 0.7),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.green, width: 0.7),
      ),
    );
//----------------------------------------------------------------//

    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 46, 46, 48),
      // appBar: const AppbarLogin(title: 'GIC Cenro Quezon'),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aztec.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 400,
                      height: 560,
                      child: Card(
                        color: const Color.fromARGB(220, 36, 36, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                          side: const BorderSide(
                            color: Color.fromARGB(245, 60, 60, 62),
                            width: 1.0,
                          ),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image.asset(
                                  'assets/icons/LOREMS.png',
                                  height: 90,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'LOREMS',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 13, 136, 69),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _usernameController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: inputDecoration.copyWith(
                                          labelText: 'Username'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _passwordController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: inputDecoration.copyWith(
                                        labelText: 'Password',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.white60,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                      obscureText: _obscurePassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    // Forgot password button aligned to the right.
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _showForgotPasswordDialog,
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 14,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Cancel Button: Shows confirmation dialog.
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showExitConfirmationDialog(
                                                  context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 236, 93, 82),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: const BorderSide(
                                                    color: Colors.white,
                                                    width: 0.7),
                                              ),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Login Button
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                await Future.delayed(
                                                    const Duration(seconds: 2));
                                                if (_usernameController.text ==
                                                        adminUsername &&
                                                    _passwordController.text ==
                                                        adminPassword) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomePage()),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Invalid username or password'),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 245, 81, 69),
                                                    ),
                                                  );
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 107, 184, 110),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: const BorderSide(
                                                    color: Colors.white,
                                                    width: 0.7),
                                              ),
                                            ),
                                            child: const Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 60),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  //_showForgotPasswordDialog

  // Future<void> _showForgotPasswordDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       int step = 0;
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           // Define variables for content text, GIF asset, and action buttons.
  //           String contentText;
  //           String gifAsset;
  //           List<Widget> actionButtons = [];

  //           // Switch-case for different steps.
  //           switch (step) {
  //             case 0:
  //               contentText = 'Itong Sayo!';
  //               gifAsset =
  //                   'assets/images/Pay Up Show Me GIF by FN Films.gif'; // Replace with your first GIF asset
  //               actionButtons = [
  //                 // Cancel button: transitions to step 1.
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         side:
  //                             const BorderSide(color: Colors.white38, width: 1),
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 60, 60, 62),
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       onPressed: () {
  //                         setState(() {
  //                           step = 1;
  //                         });
  //                       },
  //                       child: const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           'Cancel',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontFamily: 'Gilroy',
  //                             color: Colors.white70,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 // Next button: transitions to step 2.
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         side:
  //                             const BorderSide(color: Colors.white38, width: 1),
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 13, 136, 69),
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       onPressed: () {
  //                         setState(() {
  //                           step = 2;
  //                         });
  //                       },
  //                       child: const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           'Next',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontFamily: 'Gilroy',
  //                             color: Colors.white70,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ];
  //               break;
  //             case 1:
  //               contentText = 'Why you canceled?';
  //               gifAsset =
  //                   'assets/images/suck my dick middle finger GIF.gif'; // Replace with your cancel GIF asset
  //               actionButtons = [
  //                 // Single Close button.
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         side:
  //                             const BorderSide(color: Colors.white38, width: 1),
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 13, 136, 69),
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       onPressed: () => Navigator.pop(context),
  //                       child: const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           'Close',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontFamily: 'Gilroy',
  //                             color: Colors.white70,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ];
  //               break;
  //             case 2:
  //               contentText =
  //                   'Kung sakaling nakalimutan mo, mangyaring makipag-ugnayan sa support team para sa assistance. Pakitandaan na importanteng tandaan ang iyong password para sa mas ligtas na account.';
  //               gifAsset =
  //                   'assets/images/Schitts Creek Please GIF by CBC.gif'; // Replace with your second GIF asset
  //               actionButtons = [
  //                 // Back button: transitions to step 3.
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         side:
  //                             const BorderSide(color: Colors.white38, width: 1),
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 60, 60, 62),
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       onPressed: () {
  //                         setState(() {
  //                           step = 3;
  //                         });
  //                       },
  //                       child: const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           'Back',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontFamily: 'Gilroy',
  //                             color: Colors.white70,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 // OK button: transitions to step 4.
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         side:
  //                             const BorderSide(color: Colors.white38, width: 1),
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 13, 136, 69),
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       onPressed: () {
  //                         setState(() {
  //                           step = 4;
  //                         });
  //                       },
  //                       child: const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           'OK',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontFamily: 'Gilroy',
  //                             color: Colors.white70,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ];
  //               break;
  //             case 3:
  //               contentText = 'Why you go back?';
  //               gifAsset =
  //                   'assets/images/Hold On Middle Finger GIF by UFC.gif'; // Replace with your back GIF asset
  //               actionButtons = [
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         side:
  //                             const BorderSide(color: Colors.white38, width: 1),
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 13, 136, 69),
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       onPressed: () => Navigator.pop(context),
  //                       child: const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           'Close',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontFamily: 'Gilroy',
  //                             color: Colors.white70,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ];
  //               break;
  //             case 4:
  //               contentText = 'All done!';
  //               gifAsset =
  //                   'assets/images/Jim Carey Reaction GIF.gif'; // Replace with your "all done" GIF asset
  //               // In step 4, show a Thank You button.
  //               actionButtons = [
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         side:
  //                             const BorderSide(color: Colors.white38, width: 1),
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 13, 136, 69),
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       onPressed: () => Navigator.pop(context),
  //                       child: const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           'Thank You',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontFamily: 'Gilroy',
  //                             color: Colors.white70,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ];
  //               break;
  //             default:
  //               contentText = '';
  //               gifAsset = '';
  //           }

  //           return AlertDialog(
  //             backgroundColor: const Color.fromARGB(255, 38, 38, 40),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16.0),
  //             ),
  //             insetPadding: const EdgeInsets.all(40),
  //             titlePadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
  //             title: Row(
  //               children: [
  //                 // Icon at the left of the title.
  //                 const Padding(
  //                   padding: EdgeInsets.only(left: 16, right: 8),
  //                   child: Icon(
  //                     Icons.lock_outline,
  //                     color: Color.fromARGB(255, 13, 136, 69),
  //                     size: 28,
  //                   ),
  //                 ),
  //                 const Expanded(
  //                   child: Text(
  //                     'Forgot Password',
  //                     style: TextStyle(
  //                       fontSize: 24,
  //                       fontWeight: FontWeight.bold,
  //                       fontFamily: 'Gilroy',
  //                       color: Colors.white60,
  //                     ),
  //                     textAlign: TextAlign.start,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   icon: const Icon(
  //                     Icons.close,
  //                     color: Color.fromARGB(255, 13, 136, 69),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             contentPadding: EdgeInsets.zero,
  //             content: SizedBox(
  //               width: 450,
  //               height: 500,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Divider(color: Colors.grey, thickness: 0.5),
  //                     const SizedBox(height: 8),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 16),
  //                       child: Text(
  //                         contentText,
  //                         style: const TextStyle(
  //                           fontSize: 18,
  //                           fontFamily: 'Gilroy',
  //                           color: Colors.white38,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     const Divider(color: Colors.grey, thickness: 0.5),
  //                     const SizedBox(height: 16),
  //                     Center(
  //                       child: Image.asset(
  //                         gifAsset,
  //                         width: 400,
  //                         height: 450,
  //                         fit: BoxFit.contain,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
  //             actions: actionButtons.isNotEmpty
  //                 ? [
  //                     Row(
  //                       children: actionButtons,
  //                     )
  //                   ]
  //                 : null,
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

// Add this function in your class
  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

// Updated _showForgotPasswordDialog method
  Future<void> _showForgotPasswordDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 38, 38, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          titlePadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.lock_reset,
                  color: Color.fromARGB(255, 13, 136, 69),
                  size: 28,
                ),
              ),
              const Expanded(
                child: Text(
                  'Account Recovery',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                    color: Colors.white60,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Color.fromARGB(255, 13, 136, 69),
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(color: Colors.grey, thickness: 0.5),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        color: Colors.white70,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Para ma-recover ang iyong account, maaaring makipag-ugnayan sa pamamagitan ng:\n\n',
                        ),
                        TextSpan(
                          text: '📧 Email: support@gicdev.com\n',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 13, 136, 69),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                _launchUrl('mailto:support@gicquezon.com'),
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: '📱 Mobile: (+63) 992-0061-931',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 13, 136, 69),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchUrl('tel:+639920061931'),
                        ),
                        const TextSpan(
                          text:
                              '\n\nMaaari ring personal na dumalaw sa aming tanggapan sa:\n'
                              'Official Office, Brgy. Maasin, Quezon, Palawan',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 0.5),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: const Color.fromARGB(255, 13, 136, 69),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: Text(
                    'Salamat',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
//showExitConfirmationDialog

  Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 38, 38, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        title: const Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Confirm Exit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                    color: Colors.white60,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey, thickness: 0.5),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Are you sure you want to exit the app?',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  color: Colors.white38,
                ),
              ),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 0.5),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: Colors.white38, width: 1),
                      backgroundColor: const Color.fromARGB(255, 60, 60, 62),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Gilroy',
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: Colors.white38, width: 1),
                      backgroundColor: Colors.red.withOpacity(0.5),
                      foregroundColor: Colors.white.withOpacity(0.5),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                      appWindow.close(); // Permanently closes the window
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Gilroy',
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
