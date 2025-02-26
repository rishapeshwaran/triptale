class TripExpanseMaster {
  final int id;
  final String title;
  final String description;
  final int numberOfMembers;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? perHeadAmount; // Optional if perHead is selected
  final double budget;

  TripExpanseMaster({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfMembers,
    required this.startDate,
    required this.endDate,
    this.perHeadAmount,
    required this.budget,
  });

  @override
  String toString() {
    return 'Trip{id: $id, title: $title, description: $description, numberOfMembers: $numberOfMembers, startDate: $startDate, endDate: $endDate, perHeadAmount: $perHeadAmount, budget: $budget}';
  }
}
