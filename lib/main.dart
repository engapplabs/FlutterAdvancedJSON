import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: new FutureBuilder<List<User>>(
            future: fetchListUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data;
                return new ListView(
                  children: users
                      .map(
                        (user) => new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text('Username: ${user.username}'),
                                new Text('Name: ${user.name}'),
                                new Text(
                                    'Lat/Lng: ${user.address.geo.lat}/${user.address.geo.lng}'),
                                new Divider(),
                              ],
                            ),
                      )
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

//Criar método para carregar a lista de usuários da API

Future<List<User>> fetchListUser() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  if (response.statusCode == 200) {
    List users = json.decode(response.body);
    return users.map((user) => new User.fromJson(user)).toList();
  } else
    throw Exception('Failed to load');
}

class User {
  final int id;
  final String name, username, email, phone, website;
  final Address address;
  final Company company;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: Address.fromJson(json['address']),
      company: Company.fromJson(json['company']),
    );
  }
}

class Address {
  final String street;
  final String suite;
  final String zipcode;
  final Geo geo;

  Address({this.street, this.suite, this.zipcode, this.geo});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }
}

class Geo {
  final String lat, lng;

  Geo({this.lat, this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({this.name, this.catchPhrase, this.bs});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }
}
