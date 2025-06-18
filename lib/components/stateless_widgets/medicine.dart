class Medicine {
  final String imageAsset;
  final String title;
  final String? type;
  final String? function;
  final String? adultDoses;
  final String? childDoses;
  final String? sideEffects;

  Medicine({
    required this.imageAsset,
    required this.title,
    this.type,
    this.function,
    this.adultDoses,
    this.childDoses,
    this.sideEffects,
  });
}
