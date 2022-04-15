import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/Models/models.dart';

import '../helpers/debouncers.dart';

class MoviesProvider extends ChangeNotifier{

	final String _baseUrl  = 'api.themoviedb.org';
	final String _apiKey   = '47a9e8139eac83b3ca5bd718e9f057be';
	final String _language = 'en-US';

	List<Movie> onDisplayMovies = [];
	List<Movie> popularMovies = [];
	Map<int, List<Cast>> moviesCast = {};

	int _popularPage = 0;

	final debouncer = Debouncer( 
		duration: Duration(milliseconds: 500),

	);
	final StreamController<List<Movie>> _suggestionsStreamController = new StreamController.broadcast();
	Stream<List<Movie>> get suggestionStream => _suggestionsStreamController.stream;

	MoviesProvider() {
		getOnDisplayMovies();
		getPopularMovies();
	}

	Future<String> _getJsonData( String endpoint, [ int page = 1]) async{
		final url = Uri.https( _baseUrl, endpoint, {
			'api_key': _apiKey,
			'language': _language,
			'page': page.toString()
		});
		
		final response = await http.get(url);
		return response.body;
	}

	getOnDisplayMovies() async {
		final jsonData = await _getJsonData("/3/movie/now_playing");
		final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
		onDisplayMovies = [...nowPlayingResponse.results];
		notifyListeners();
	}

	getPopularMovies() async {
		_popularPage++;
		final jsonData = await _getJsonData("/3/movie/popular", _popularPage);
		final popularResponse = PopularResponse.fromJson( jsonData );
		if( popularMovies == null) {
			popularMovies = [...popularResponse.results];
		} else {
			popularMovies.addAll(popularResponse.results);
		}
		
		notifyListeners();
	}

	Future<List<Cast>> getMovieCast( int movieId) async{

		if( moviesCast.containsKey(movieId)) {
			return moviesCast[movieId]!;
		}
		
		final jsonData = await _getJsonData("/3/movie/$movieId/credits");
		final creditsResponse = CreditsResponse.fromJson( jsonData );

		moviesCast[movieId] = creditsResponse.cast;
		return creditsResponse.cast;
	}

	Future<List<Movie>> searchMovies( String  query) async{
		final url = Uri.https( _baseUrl, '3/search/movie', {
			'api_key': _apiKey,
			'language': _language,
			'query': query,
		});
		
		final response = await http.get(url);

		try {
			final response = await http.get(url);
			final searchResponse = SearchMovieResponse.fromJson(response.body);
			return searchResponse.results;
		} catch (error) {
			final List<Movie> list = [];
			return list;
    	}
	}

	void getSuggestionsByQuery( String searchTerm) {
		debouncer.value = '';
		debouncer.onValue = ( value ) async {
			final results = await searchMovies(value);
			_suggestionsStreamController.add(results);
		};

		final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
			debouncer.value = searchTerm;
		 });

		 Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
	}
}