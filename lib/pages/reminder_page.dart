import 'package:flutter/material.dart';
import 'package:obatku/components/stateful_widgets/medicine_card.dart';
import 'package:obatku/components/stateful_widgets/selected_day.dart';
import 'package:obatku/components/stateless_widgets/medicine.dart';
import 'package:obatku/pages/detail_medicine.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  int selectedIndex = 0;
  final List<DateTime> days = List.generate(7, (i) => DateTime(2025, 6, 7 + i));

  void onChanged(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFE8E5FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/pfp.jpg'),
                    backgroundColor: Colors.black,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.nightlight_round, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.notifications_none, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Don\'t Forget to be',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'Healthy!',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SelectedDay(
                days: days,
                selectedIndex: selectedIndex,
                onChanged: onChanged,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'What You Must Take',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.sort, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final medicinesData = [
                    {
                      'imageAsset': 'assets/images/Amoxicillin.png',
                      'title': 'Amoxicillin',
                      'type': 'Antibiotik penisilin.',
                    },
                    {
                      'imageAsset': 'assets/images/ibuprofen.png',
                      'title': 'Ibuprofen',
                      'type': 'Antiinflamasi nonsteroid (AINS).',
                    },
                    {
                      'imageAsset': 'assets/images/metaformin.png',
                      'title': 'Metaformin',
                      'type': 'Antidiabetik oral.',
                    },
                    {
                      'imageAsset': 'assets/images/paracetamol.png',
                      'title': 'Paracetamol',
                      'type': 'Antipiretik dan analgesik.',
                    },
                  ];
                  final medicineData = medicinesData[index];
                  final medicine = Medicine(
                    title: medicineData['title']!,
                    type: medicineData['type']!,
                    imageAsset: medicineData['imageAsset']!,
                  );

                  return MedicineCard(
                    title: medicine.title,
                    type: medicine.type!,
                    imagePath: medicine.imageAsset,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailMedicine(medicine: medicine),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
