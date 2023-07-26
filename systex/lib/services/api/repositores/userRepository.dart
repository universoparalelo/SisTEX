// ignore: file_names
abstract class UserRepository {
  Future<Map<String, dynamic>> authUser(String email, String password);
}
