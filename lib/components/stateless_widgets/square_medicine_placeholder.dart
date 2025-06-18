import 'package:flutter/material.dart';
import 'package:obatku/components/stateless_widgets/medicine.dart';
import 'package:obatku/pages/detail_medicine.dart';

class SquareMedicinePlaceholder extends StatelessWidget {
  final Medicine medicine;
  final int index;

  const SquareMedicinePlaceholder({
    super.key,
    required this.medicine,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMedicine(medicine: medicine),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  medicine.imageAsset,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  medicine.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
