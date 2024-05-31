class DonationDrive {
  String id;
  String title;
  String description;
  List<String> imageUrls;
  double raisedAmount;
  double goalAmount;

  DonationDrive({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.raisedAmount,
    required this.goalAmount,
  });
}
