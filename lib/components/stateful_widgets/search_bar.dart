import 'package:flutter/material.dart';
import 'package:obatku/components/stateless_widgets/search_chip.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget leading;

  const SearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.leading = const Icon(Icons.search, color: Colors.black, size: 28),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 4.0),
                Expanded(
                  child: SizedBox(
                    height: 4,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),

          Wrap(
            spacing: 10,
            children: [
              SearchChip(
                text: 'Vitamin C',
                color: Colors.yellow,
                textColor: Colors.black,
              ),
              SearchChip(
                text: 'CTM',
                color: Colors.blue,
                textColor: Colors.white,
              ),
              SearchChip(
                text: 'Lactobin',
                color: Colors.greenAccent,
                textColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
