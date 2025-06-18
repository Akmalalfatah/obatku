import 'package:flutter/material.dart';
import 'package:obatku/components/stateless_widgets/medicine.dart';

class DetailMedicine extends StatelessWidget {
  final Medicine medicine;

  const DetailMedicine({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E5FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 40),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Medicine image
            Image.asset(medicine.imageAsset, height: 180),
            const SizedBox(height: 12),

            // Container utama
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFCFDAFF),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol REMOVE
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(120, 50),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "REMOVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Nama Obat
                  Text(
                    medicine.title,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Fungsi obat
                  Text(
                    medicine.function ?? "Tidak tersedia",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),

                  // Info Box panjang
                  infoBox("Tipe Obat", medicine.type ?? "Tidak tersedia"),
                  infoBox(
                    "Dosis Dewasa",
                    medicine.adultDoses ?? "Tidak tersedia",
                  ),
                  infoBox(
                    "Dosis Anak",
                    medicine.childDoses ?? "Tidak tersedia",
                  ),
                  infoBox(
                    "Efek Samping",
                    medicine.sideEffects ?? "Tidak tersedia",
                  ),

                  const SizedBox(height: 24),

                  // Tombol Edit Schedule
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF86B2),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Edit Schedule",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // InfoBox panjang (full width)
  Widget infoBox(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
