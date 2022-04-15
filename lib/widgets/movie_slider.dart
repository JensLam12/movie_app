import 'package:flutter/material.dart';
import '../Models/Models.dart';


class MovieSlider extends StatefulWidget {
	final List<Movie> movies;
	final String? title;
	final Function onNextPage;

	const MovieSlider({
		Key? key, 
		required this.movies, 
		this.title, 
		required this.onNextPage
	}) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

	final ScrollController scrollController = new ScrollController();
	bool _getMoreData = false;

	@override
	void initState() {
		super.initState();

		scrollController.addListener(() {
			if( scrollController.position.pixels == scrollController.position.maxScrollExtent - 500) {
				_getMoreData = true;
				widget.onNextPage();
			} else {
				_getMoreData = false;
				if( scrollController.position.pixels == scrollController.position.maxScrollExtent) {
					this.widget.onNextPage();
				}
			}
		});
	}

	@override
	void dispose() {
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			height: 260,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					if( widget.title != null)
						Padding(
							padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
							child: Text( widget.title!, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
						),
					Expanded(
						child: ListView.builder(
							controller: scrollController,
							scrollDirection: Axis.horizontal,
							itemCount: widget.movies.length,
							itemBuilder: ( _, int index ) => _MoviePoster(movie: widget.movies[index], heroId: '${widget.title}-${index}-${widget.movies[index].id}')
						),
					)
				],
			),
		);
	}
}


class _MoviePoster extends StatelessWidget {
	final Movie movie;
	final String heroId;
	
	const _MoviePoster({
		Key? key, 
		required this.movie, 
		required this.heroId
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {

		movie.heroId = heroId;

		return Container(
			width: 130,
			height: 190,
			margin: const EdgeInsets.symmetric( horizontal: 10),
			child: Column(
				children: [
					GestureDetector(
						onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
						child: Hero(
							tag: movie.heroId!,
							child: ClipRRect(
								borderRadius: BorderRadius.circular(20),
								child: FadeInImage(
									placeholder: const AssetImage('assets/no-image.jpg'), 
									image: NetworkImage( movie.fullPosterImg ),
									width: 130,
									height: 190,
									fit: BoxFit.cover,
								),
							),
						),
					),
					const SizedBox( height: 5,),
					Text( movie.originalTitle , overflow: TextOverflow.ellipsis,maxLines: 1, textAlign: TextAlign.center,)

				],
			),
		);
	}
}