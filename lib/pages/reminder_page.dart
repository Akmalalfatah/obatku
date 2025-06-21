import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obatku/components/stateful_widgets/medicine_card.dart';
import 'package:obatku/components/stateful_widgets/selected_day.dart';
import 'package:obatku/components/stateless_widgets/medicine.dart';
import 'package:obatku/components/stateless_widgets/medicine_component_list.dart';
import 'package:obatku/pages/detail_medicine.dart';
import 'package:intl/intl.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  int selectedIndex = 0;
  final List<DateTime> days = List.generate(
    7,
    (i) => DateTime(2025, 6, 25 + i),
  );
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Medicine> currentMedicines = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    // Ambil data obat untuk tanggal pertama (hari ini)
    _loadMedicinesForDate(days[selectedIndex]);
  }

  void onChanged(int i) {
    setState(() {
      selectedIndex = i;
    });
    _loadMedicinesForDate(days[i]);
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
                    child: IconButton(
                      icon: const Icon(Icons.sort, size: 28),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.add),
                                  title: const Text('Tambah Obat'),
                                  onTap: () => _showMedicinePicker(context),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Hapus Obat'),
                                  onTap: () => _showDeleteDialog(context),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              currentMedicines.isEmpty
                  ? const Center(
                      child: Text('Tidak ada obat untuk tanggal ini'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentMedicines.length > 4
                          ? 4
                          : currentMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = currentMedicines[index];
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

  //medicinepicker
  void _showMedicinePicker(BuildContext context) async {
    final allMedicines = await MedicineComponentList.getMedicines();
    final selected = <String>{};
    final formattedDate = DateFormat('yyyy-MM-dd').format(days[selectedIndex]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pilih Obat untuk Ditambahkan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ...allMedicines.map((medicine) {
                    final isSelected = selected.contains(medicine.title);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(medicine.title),
                      onChanged: (value) {
                        setModalState(() {
                          if (value == true) {
                            selected.add(medicine.title);
                          } else {
                            selected.remove(medicine.title);
                          }
                        });
                      },
                    );
                  }).toList(),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('reminders')
                          .doc(formattedDate)
                          .set({
                            'medicines': FieldValue.arrayUnion(
                              selected.toList(),
                            ),
                          }, SetOptions(merge: true));

                      Navigator.pop(context);
                      _loadMedicinesForDate(days[selectedIndex]);
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //deletedialog
  void _showDeleteDialog(BuildContext context) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(days[selectedIndex]);
    final doc = await FirebaseFirestore.instance
        .collection('reminders')
        .doc(formattedDate)
        .get();

    if (!doc.exists || !(doc.data()?['medicines'] is List)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada obat untuk dihapus')),
      );
      return;
    }

    final existing = List<String>.from(doc['medicines']);
    final toDelete = <String>{};

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Hapus Obat dari Hari Ini'),
              content: SingleChildScrollView(
                child: Column(
                  children: existing.map((title) {
                    return CheckboxListTile(
                      value: toDelete.contains(title),
                      title: Text(title),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            toDelete.add(title);
                          } else {
                            toDelete.remove(title);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('reminders')
                        .doc(formattedDate)
                        .update({
                          'medicines': FieldValue.arrayRemove(
                            toDelete.toList(),
                          ),
                        });

                    Navigator.pop(context);
                    _loadMedicinesForDate(days[selectedIndex]);
                  },
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //loadmedicine untuk date
  void _loadMedicinesForDate(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final doc = await FirebaseFirestore.instance
        .collection('reminders')
        .doc(formattedDate)
        .get();

    if (doc.exists && doc.data()!.containsKey('medicines')) {
      final medicineTitles = List<String>.from(doc['medicines']);
      final allMedicines = await MedicineComponentList.getMedicines();
      if (!mounted) return;
      setState(() {
        currentMedicines = allMedicines
            .where((m) => medicineTitles.contains(m.title))
            .toList();
      });
    } else {
      setState(() {
        currentMedicines = [];
      });
    }
  }
}
