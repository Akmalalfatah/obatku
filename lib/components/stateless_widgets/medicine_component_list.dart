import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obatku/components/stateless_widgets/medicine.dart';

class MedicineComponentList {
  // Reference to the Firestore collection
  static final CollectionReference _medicinesCollection = FirebaseFirestore
      .instance
      .collection('medicines');

  // Fetch medicines from Firestore (one-time fetch)
  static Future<List<Medicine>> getMedicines() async {
    try {
      QuerySnapshot snapshot = await _medicinesCollection.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Medicine(
          imageAsset: data['imageAsset'] ?? '',
          title: data['title'] ?? '',
          type: data['type'],
          function: data['function'],
          adultDoses: data['adultDoses'],
          childDoses: data['childDoses'],
          sideEffects: data['sideEffects'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching medicines: $e');
      return [];
    }
  }

  // Optional: Stream for real-time updates
  static Stream<List<Medicine>> streamMedicines() {
    return _medicinesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Medicine(
          imageAsset: data['imageAsset'] ?? '',
          title: data['title'] ?? '',
          type: data['type'],
          function: data['function'],
          adultDoses: data['adultDoses'],
          childDoses: data['childDoses'],
          sideEffects: data['sideEffects'],
        );
      }).toList();
    });
  }
}
