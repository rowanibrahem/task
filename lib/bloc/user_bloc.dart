import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// User-related events
abstract class UserEvent {}

class FetchUsersEvent extends UserEvent {}

// User-related states
abstract class UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final List<User> users;

  UserLoadedState(this.users);
}

class UserErrorState extends UserState {
  final String errorMessage;

  UserErrorState(this.errorMessage);
}

// User-related bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoadingState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is FetchUsersEvent) {
      yield UserLoadingState();

      final result = await _fetchUsers();
      if (result is List<User>) {
        yield UserLoadedState(result);
      } else {
        yield UserErrorState(result as String);
      }
    }
  }

  Future<List<User>> _fetchUsers() async {
    try {
      final response =
      await http.get(Uri.parse('https://gorest.co.in/public-api/users'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userList = data['data'] as List;

        return userList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch users. Please try again later.');
      }
    } catch (e) {
      throw Exception('An error occurred. Please try again later.');
    }
  }
}

// User model
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
