
class Donation {
  //All the variables that are needed to be shown in the summary are placed here
  String? orgName;
  final bool checkFood;
  final bool checkClothes;
  final bool checkCash;
  final bool checkNecessities;
  //final String? others;
  final bool checkLogistics;
  final String date;
  final String? address;
  final String? contactNo;
  final String weight;


        Donation({required this.orgName,
                  required this.checkFood,
                  required this.checkClothes, 
                  required this.checkCash,
                  required this.checkNecessities,
                  required this.checkLogistics,
                  required this.date, 
                  this.address,
                  this.contactNo,
                  required this.weight});
}
