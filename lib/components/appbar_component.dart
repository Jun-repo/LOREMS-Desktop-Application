// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:giccenroquezon/login_page.dart';

class AppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppbarComponent({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 22, 22, 24),
        image: DecorationImage(
          image: AssetImage('assets/images/forest.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: WindowTitleBarBox(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // Left Side AppBar: Logo and Title.
                  Image.asset(
                    'assets/icons/LOREMS.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TimesNewRoman',
                    ),
                  ),
                  // Right Side AppBar: User Menu and Window Buttons.
                  const Spacer(),
                  const SizedBox(width: 20),
                  const UserMenu(),
                  const SizedBox(width: 20),
                  const CustomWindowButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  UserMenuState createState() => UserMenuState();
}

class UserMenuState extends State<UserMenu> {
  bool _menuOpen = false;

  Future<void> _showAboutSoftwareDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        bool isExpanded = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 200,
              width: 150,
              child: AlertDialog(
                backgroundColor: const Color.fromARGB(255, 38, 38, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                titlePadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                title: const Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'About Software',
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
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Policies & Agreements',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy',
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'By using this software, you agree to our Privacy Policy and Terms of Use. \nAll data is handled according to our strict security protocols. \nPlease read them carefully before proceeding.',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Application Name: EnviroSort',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            color: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Version: 1.0.0',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            color: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Developer: Amadeo T. Amasan III',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            color: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Privacy Policy & Terms of Use',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: Colors.white54,
                              ),
                              onPressed: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                            ),
                          ],
                        ),
                        if (isExpanded)
                          const Text(
                            'DENR strictly enforces data privacy and all data processing is regulated under national standards. The purpose of this software is to sort and manage documents securely. Only authorized personnel are allowed to access the system, ensuring that sensitive information remains confidential. All users must comply with the policies and guidelines established by DENR, and any breach of security will be subject to legal action. Please ensure you understand the terms before proceeding.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Gilroy',
                              color: Colors.white54,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                      ],
                    ),
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
                        side: const BorderSide(color: Colors.white38, width: 1),
                        backgroundColor: const Color.fromARGB(255, 60, 60, 62),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Close',
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
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 38, 38, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        title: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Confirm Logout',
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
            IconButton(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(
                Icons.close,
                color: Color.fromARGB(255, 13, 136, 69),
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
                'Are you sure you want to logout?\nDont forget your username and password for the next login.',
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
                    onPressed: () => Navigator.pop(context, true),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Logout',
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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(
            color: Color.fromARGB(255, 13, 136, 69), width: 0.4),
      ),
      color: const Color.fromRGBO(44, 44, 46, 5),
      onOpened: () {
        setState(() {
          _menuOpen = true;
        });
      },
      onCanceled: () {
        setState(() {
          _menuOpen = false;
        });
      },
      onSelected: (value) async {
        setState(() {
          _menuOpen = false;
        });
        if (value == 'About Software') {
          _showAboutSoftwareDialog();
        } else if (value == 'Logout') {
          bool? shouldLogout = await _showLogoutDialog(context);
          if (shouldLogout == true) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          debugPrint('Selected: $value');
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'About Software',
          child: Text(
            'About Software',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Logout',
          child: Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white30,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            _menuOpen ? Icons.arrow_downward : Icons.arrow_upward,
            size: 16,
            color: const Color.fromARGB(255, 13, 136, 69),
          ),
        ],
      ),
    );
  }
}

class CustomWindowButtons extends StatelessWidget {
  const CustomWindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color.fromARGB(255, 60, 60, 62),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomWindowButton(
                icon: Icons.remove_rounded,
                normalColor: Colors.white38,
                hoverColor: const Color.fromARGB(255, 13, 136, 69),
                onPressed: () => appWindow.minimize(),
                size: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomWindowButton(
                icon: appWindow.isMaximized
                    ? Icons.crop_square_rounded
                    : Icons.check_box_outline_blank,
                normalColor: Colors.white38,
                hoverColor: const Color.fromARGB(255, 13, 136, 69),
                onPressed: () => appWindow.maximizeOrRestore(),
                size: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomWindowButton(
                icon: Icons.close_rounded,
                normalColor: Colors.white38,
                hoverColor: Colors.redAccent,
                onPressed: () => appWindow.close(),
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWindowButton extends StatefulWidget {
  final IconData icon;
  final Color normalColor;
  final Color hoverColor;
  final VoidCallback onPressed;
  final double size;
  const CustomWindowButton({
    super.key,
    required this.icon,
    required this.normalColor,
    required this.hoverColor,
    required this.onPressed,
    this.size = 30.0,
  });

  @override
  State<CustomWindowButton> createState() => _CustomWindowButtonState();
}

class _CustomWindowButtonState extends State<CustomWindowButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: isHovered ? widget.hoverColor : widget.normalColor,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                widget.icon,
                size: widget.size * 0.6,
                color: isHovered ? widget.hoverColor : widget.normalColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
