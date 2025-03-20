import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class AppbarLogin extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppbarLogin({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(22, 22, 24, 5),
            Color.fromRGBO(24, 24, 28, 5)
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
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
                  //Left Side AppBar

                  Image.asset(
                    'assets/icons/denr-logo.webp',
                    width: 50,
                    height: 50,

                    // color: Colors.white,
                  ),

                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Right Side Appbar
                  const Spacer(),

                  const SizedBox(width: 40),

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
  final String username = "Jun";

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
      onSelected: (value) {
        debugPrint('Selected: $value');
        setState(() {
          _menuOpen = false;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Account',
          child: Text(
            'Account',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Profile',
          child: Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Settings',
          child: Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Support',
          child: Text(
            'Support',
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
              child: Text(
                'J',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            username,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
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
