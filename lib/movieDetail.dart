import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perejil_app/models/movie.dart';
import 'dart:convert';
import 'models/movieDetailModel.dart';
import 'package:intl/intl.dart';

const apiKey = 'c0263648253fb8870543c4e61d4586f6';
const baseUrl = 'https://api.themoviedb.org/3/movie/';
const baseImageUrl = 'https://image.tmdb.org/t/p/';

class MovieDetail extends StatefulWidget {
  final Results movie;

  MovieDetail({this.movie});

  @override
  _MovieDetails createState() => new _MovieDetails();

}

class _MovieDetails extends State<MovieDetail> {
  String movieDetailUrl;
  MovieDetailModel movieDetailModel;

  @override
  void initState() {
    super.initState();
    movieDetailUrl = "${baseUrl}${widget.movie.id}?api_key=${apiKey}";
    _fetchMovieDetails();

  }

  void _fetchMovieDetails() async {
    var response = await http.get(movieDetailUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      movieDetailModel = MovieDetailModel.fromJson(decodeJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Perejil App',
          style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container( color: Colors.purple ),
        ],
      ),
    );
  }
}