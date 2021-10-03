import 'models/sharedpref.dart';

String amenityDir = 'images_aminities/';

class Amenities {
  List<String> facilities = [
    "24X7 Female Caretaker",
    "24X7 Male Caretaker",
    '24X7 Security Guards',
    'AC Study Room',
    'Biometric Entry/Exit Gate',
    'CCTV',
    'Clean Common Washrooms',
    'Common Room TV',
    'Food from Centralised Kitchen',
    'Fridge',
    'Free Hi-Speed WiFi',
    'Lift',
    'Low-cost Laundry Service',
    'Power Backup',
    'Professional Housekeeping',
    'RO Water',
    'Unlimited Free of Charge Doctor Consultation',
    'Water Cooler',
  ];

  List<String> amenityIcon = [
    amenityDir + 'babysitter.png',
    amenityDir + 'man.png',
    amenityDir + 'policeman.png',
    amenityDir + 'air-conditioner.png',
    amenityDir + 'fingerprint.png',
    amenityDir + 'security-camera.png',
    amenityDir + 'water-closet.png',
    amenityDir + 'tv.png',
    amenityDir + 'kitchen-tools.png',
    amenityDir + 'fridge.png',
    amenityDir + 'wifi.png',
    amenityDir + 'elevator.png',
    amenityDir + 'washing-machine.png',
    amenityDir + 'energy.png',
    amenityDir + 'housekeeping.png',
    amenityDir + 'purifier.png',
    amenityDir + 'doctor.png',
    amenityDir + 'water-cooler.png',
  ];

  List<String> amenityText = [
    "Female Caretaker",
    "Male Caretaker",
    'Security Guards',
    'AC Study Room',
    'Biometric\nEntry/Exit Gate',
    'CCTV',
    'Clean\nCommon Washrooms',
    'Common Room TV',
    'Food from\nCentralised Kitchen',
    'Fridge',
    'Free WiFi',
    'Lift',
    'Low-cost\nLaundry Service',
    'Power Backup',
    'Professional\nHousekeeping',
    'RO Water',
    'Free Doctor\nConsultation',
    'Water Cooler',
    "",
  ];

  int getAmenitiesLength() {
    return MySharedPref.getCommonFacilities()!.length;
  }

  int getAmenitiesIndex(int index) {
    return MySharedPref.getCommonFacilities()![index];
  }
}
