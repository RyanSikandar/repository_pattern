import 'package:repo_pattern/data/model/user_model.dart';
import 'package:repo_pattern/data/provider/user_provider.dart';

abstract class IUserRepository {
  Future<UserModel> getUsers();
}

class UserRepository implements IUserRepository {
  final UserProvider userProvider;
  UserRepository(this.userProvider);

  @override
  Future<UserModel> getUsers() {
    return userProvider.getUsers();
  }
}
