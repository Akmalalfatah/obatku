import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obatku/components/stateless_widgets/medicine.dart';

class MedicineUploader {
  static final CollectionReference _medicinesCollection = FirebaseFirestore
      .instance
      .collection('medicines');

  static Future<void> uploadMedicines() async {
    List<Medicine> medicines = [
      Medicine(
        imageAsset: 'assets/images/Amoxicillin.png',
        title: 'Amoxicillin',
        type: 'Antibiotik penisilin.',
        function:
            'Mengobati infeksi bakteri (tenggorokan, THT, saluran kemih, dll)',
        adultDoses: '500 mg setiap 8 jam.',
        childDoses:
            '20–40 mg/kgBB/hari (infeksi ringan–sedang), dibagi tiap 8 jam.',
        sideEffects: 'Diare, reaksi alergi, mual.',
      ),
      Medicine(
        imageAsset: 'assets/images/ibuprofen.png',
        title: 'Ibuprofen',
        type: 'Antiinflamasi nonsteroid (AINS).',
        function: 'Meredakan nyeri, peradangan, dan demam.',
        adultDoses:
            '200–400 mg setiap 4–6 jam, maksimal 1.200 mg per hari tanpa resep dokter.',
        childDoses:
            '20–40 mg/kgBB/hari (infeksi ringan–sedang), dibagi tiap 8 jam.',
        sideEffects: 'Iritasi lambung, mual, pusing.',
      ),
      Medicine(
        imageAsset: 'assets/images/metaformin.png',
        title: 'Metaformin',
        type: 'Antidiabetik oral.',
        function: 'Mengontrol gula darah pada diabetes tipe 2.',
        adultDoses: '500–2 000 mg per hari (dibagi 2–3 kali).',
        childDoses: 'Mulai 500 mg 1–2× sehari.',
        sideEffects:
            'Mual, diare, rasa logam, risiko asidosis laktat (jarang).',
      ),
      Medicine(
        imageAsset: 'assets/images/paracetamol.png',
        title: 'Paracetamol',
        type: 'Antipiretik dan analgesik.',
        function: 'Menurunkan demam dan meredakan nyeri ringan.',
        adultDoses: '500–1.000 mg setiap 4–6 jam, maksimal 4.000 mg per hari.',
        childDoses:
            '10–15 mg/kgBB setiap 4–6 jam, maksimal 60 mg/kgBB per hari.',
        sideEffects: 'Mual, gangguan hati jika dikonsumsi berlebihan.',
      ),
      Medicine(
        imageAsset: 'assets/images/Omeprazole.png',
        title: 'Omeprazole',
        type: 'Inhibitor pompa proton.',
        function: 'Mengurangi asam lambung (GERD, tukak lambung).',
        adultDoses: '20–40 mg per hari, 1× sebelum makan.',
        childDoses: '0.7–3.5 mg/kgBB/hari, sesuai kondisi & berat badan.',
        sideEffects:
            'Sakit kepala, diare, kembung, risiko gangguan elektrolit jangka panjang.',
      ),
      Medicine(
        imageAsset: 'assets/images/Loratadine.png',
        title: 'Loratadine',
        type: 'Antihistamin non-sedatif.',
        function: 'Mengobati alergi seperti rhinitis alergi dan urtikaria.',
        adultDoses: '10 mg sekali sehari.',
        childDoses: '5 mg sekali sehari (usia 2–5 tahun), 10 mg (≥6 tahun).',
        sideEffects: 'Mengantuk (ringan), mulut kering, pusing.',
      ),
      Medicine(
        imageAsset: 'assets/images/Dexamethasone.png',
        title: 'Dexamethasone',
        type: 'Kortikosteroid.',
        function:
            'Mengatasi peradangan, alergi berat, autoimun, edema otak, terapi COVID-19.',
        adultDoses: '10.5–6 mg per hari.',
        childDoses: '0.02–0.3 mg/kgBB/hari, dibagi 1–4 dosis.',
        sideEffects:
            'Nafsu makan meningkat, susah tidur, tekanan darah naik, moon face, risiko infeksi.',
      ),
      Medicine(
        imageAsset: 'assets/images/Citrizine.png',
        title: 'Cetirizine',
        type: 'Antihistamin generasi kedua.',
        function:
            'Meredakan gejala alergi seperti gatal, bersin, dan hidung meler.',
        adultDoses: '10 mg sekali sehari.',
        childDoses: '5 mg/hari (usia 2–6 tahun), 10 mg/hari (≥6 tahun).',
        sideEffects: 'Mengantuk, pusing, mulut kering.',
      ),
    ];

    try {
      for (var medicine in medicines) {
        await _medicinesCollection.doc(medicine.title).set({
          'imageAsset': medicine.imageAsset,
          'title': medicine.title,
          'type': medicine.type,
          'function': medicine.function,
          'adultDoses': medicine.adultDoses,
          'childDoses': medicine.childDoses,
          'sideEffects': medicine.sideEffects,
        });
      }
      print('Medicines uploaded successfully!');
    } catch (e) {
      print('Error uploading medicines: $e');
    }
  }
}
