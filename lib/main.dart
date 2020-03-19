import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movie.dart';
import 'package:carousel_slider/carousel_slider.dart';

const baseUrl = 'https://api.themoviedb.org/3/movie/';
const baseImageUrl = 'https://image.tmdb.org/t/p/';
const apiKey = 'c0263648253fb8870543c4e61d4586f6';

const nowPlayingUrl =
    "${baseUrl}now_playing?api_key=${apiKey}&language=es-ES&page=1";
const upcomingUrl =
    "${baseUrl}upcoming?api_key=${apiKey}&language=es-ES&page=1";
const popularUrl = "${baseUrl}popular?api_key=${apiKey}&language=es-ES&page=1";
const topRatedUrl =
    "${baseUrl}top_rated?api_key=${apiKey}&language=es-ES&page=1";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perejil App',
      theme: ThemeData.dark(),
      home: PerejilApp(),
    ));

class PerejilApp extends StatefulWidget {
  @override
  _PerejilApp createState() => new _PerejilApp();
}

class _PerejilApp extends State<PerejilApp> {
  Movie nowPlayingMovies;
  Movie upcomingMovies;
  Movie popularMovies;
  Movie topRatedMovies;
  int heroTag = 0;

  @override
  void initState() {
    super.initState();
    _fetchNowPlayMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMovies();
  }

  void _fetchNowPlayMovies() async {
    var response = await http.get(nowPlayingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      nowPlayingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchUpcomingMovies() async {
    var response = await http.get(upcomingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      upcomingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(popularUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchTopRatedMovies() async {
    var response = await http.get(topRatedUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodeJson);
    });
  }

  Widget _buildMovieListItem(Results movieItem) => Material(
        child: Container(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(6.0),
                  child: _buildMovieItem(movieItem)),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  movieItem.title,
                  style: TextStyle(fontSize: 8.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 6.0, top: 2.0),
                  child: Text(
                    movieItem.releaseDate,
                    style: TextStyle(fontSize: 8.0),
                  ))
            ],
          ),
        ),
      );

  Widget _buildMovieItem(Results movieItem) {
    heroTag += 1;
    return Material(
        elevation: 15.0,
        child: InkWell(
            onTap: () {},
            child: Hero(
                tag: heroTag,
                child: Image.network(
                    "${baseImageUrl}w342${movieItem.posterPath}",
                    fit: BoxFit.cover))));
  }

  Widget _buildCarouselSlider() => CarouselSlider(
        items: nowPlayingMovies == null
            ? <Widget>[Center(child: CircularProgressIndicator())]
            : nowPlayingMovies.results
                .map((movieItem) => _buildMovieItem(movieItem))
                .toList(),
        autoPlay: false,
        height: 240.0,
        viewportFraction: 0.5,
      );

  Widget _buildMoviesListView(Movie movie, String movieListTitle) => Container(
        height: 258.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
                child: Text(movieListTitle,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]))),
            Flexible(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: movie == null
                  ? <Widget>[Center(child: CircularProgressIndicator())]
                  : movie.results.map((movieItem) => Padding(
                      padding: EdgeInsets.only(left: 6.0, right: 2.0),
                      child: _buildMovieListItem(movieItem))).toList(),
            ))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Perejil App',
          style: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('NOW PLAYING',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              expandedHeight: 290.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "${baseImageUrl}w500/aQvJ5WPzZgYVDrxLX4R6cLJCEaQ.jpg",
                        fit: BoxFit.cover,
                        width: 1000,
                        colorBlendMode: BlendMode.dstATop,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: _buildCarouselSlider())
                  ],
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            _buildMoviesListView(upcomingMovies, 'COMMING SOON'),
            _buildMoviesListView(popularMovies, 'POPULAR MOVIES'),
            _buildMoviesListView(topRatedMovies, 'TOP RATED')
          ],
        ),
      ),
    );
  }
}
