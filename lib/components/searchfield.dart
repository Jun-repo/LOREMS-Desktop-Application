import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;

  const SearchField({
    super.key,
    required this.hintText,
    required this.onSearch,
  });

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  bool _isHovered = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
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
        child: Container(
          width: 400,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(44, 44, 46, 5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? const Color.fromARGB(255, 0, 236, 35)
                  : const Color.fromARGB(255, 13, 136, 69),
              width: 0.7,
            ),
          ),
          child: TextField(
            controller: _controller,
            cursorColor: Colors.white,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            onChanged: (query) {
              // Call the provided callback whenever the query changes.
              widget.onSearch(query);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.white38,
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 0, 236, 35),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 16, top: 7, bottom: 3, right: 8),
            ),
          ),
        ),
      ),
    );
  }
}
