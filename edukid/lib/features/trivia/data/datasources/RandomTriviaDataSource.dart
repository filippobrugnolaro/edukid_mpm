import 'dart:convert';

import '../../../../core/errors/Exception.dart';
import '../models/RandomTriviaModel.dart';

import 'package:http/http.dart' as http;

abstract class RandomTriviaRemoteDataSource {
  Future<RandomTriviaModel> getRandomTrivia(String typeQuestion, String answer);
}

class RandomTriviaRemoteDataSourceImpl implements RandomTriviaRemoteDataSource {

  final http.Client client;

  RandomTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<RandomTriviaModel> getRandomTrivia(String typeQuestion, String numberQuestion) async {
    final response = await client.get(
    Uri(scheme: 'https', host: 'edu-kid-default-rtdb.europe-west1.firebasedatabase.app', path: '$typeQuestion/question$numberQuestion/' ),
    headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return RandomTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

/*  Future<RandomTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return RandomTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }*/
}