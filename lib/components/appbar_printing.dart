import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class AppbarPrinting extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppbarPrinting({super.key, required this.title});

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
            Color.fromRGBO(24, 24, 28, 5),
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
                  // Inline HoverBackButton widget
                  const _HoverBackButton(),

                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
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

// HoverBackButton widget defined inline.
class _HoverBackButton extends StatefulWidget {
  const _HoverBackButton();

  @override
  _HoverBackButtonState createState() => _HoverBackButtonState();
}

class _HoverBackButtonState extends State<_HoverBackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color.fromARGB(255, 32, 32, 34),
          child: CircleAvatar(
            backgroundColor: _isHovered
                ? const Color.fromARGB(255, 42, 42, 44)
                : const Color.fromARGB(255, 32, 32, 34),
            child: const Icon(Icons.arrow_back, color: Colors.white70),
          ),
        ),
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
