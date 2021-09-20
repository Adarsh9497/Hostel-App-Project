import 'package:hive/hive.dart';

part 'hiveoffers_model.g.dart';

@HiveType(typeId: 0)
class OwnerOffers {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String details;

  @HiveField(2)
  final String timePeriod;

  @HiveField(3)
  final DateTime timeCreated;

  OwnerOffers(
      {required this.title,
      required this.details,
      required this.timeCreated,
      required this.timePeriod});
}
