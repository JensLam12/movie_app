import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/Models/models.dart';

class MoviesProvider extends ChangeNotifier{

	final String _baseUrl  = 'api.themoviedb.org';
	final String _apiKey   = '47a9e8139eac83b3ca5bd718e9f057be';
	final String _language = 'en-US';

	List<Movie> onDisplayMovies = [];
	List<Movie> popularMovies = [];

	MoviesProvider() {
		getOnDisplayMovies();
		getPopularMovies();
	}

	getOnDisplayMovies() async {
		var url = Uri.https( _baseUrl, '/3/movie/now_playing', {
			'api_key': _apiKey,
			'language': _language,
			'page': '1'
		});
		
		// Await the http get response, then decode the json-formatted response.
		final response = await http.get(url);
		if (response.statusCode == 200) {
			final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
			onDisplayMovies = [...nowPlayingResponse.results];
			notifyListeners();
		} 
	}

	getPopularMovies() async {
		var url = Uri.https( _baseUrl, '/3/movie/popular', {
			'api_key': _apiKey,
			'language': _language,
			'page': '1'
		});
		
		// Await the http get response, then decode the json-formatted response.
		final response = await http.get(url);
		if (response.statusCode == 200) {
			final popularResponse = PopularResponse.fromJson(response.body);
			onDisplayMovies = [...popularResponse.results];
			notifyListeners();
		} 
	}
}