import 'package:systex/models/personal.dart';

abstract class PersonalRepository {
  Future<List<Personal>> getPersonal();
}
