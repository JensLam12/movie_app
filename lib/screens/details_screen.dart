import 'package:flutter/material.dart';
import 'package:movies_app/widgets/widgets.dart';
import '../Models/Models.dart';

class DetailsScreen extends StatelessWidget {
	
  	const DetailsScreen({Key? key}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

		return Scaffold(
			body:  CustomScrollView(
				slivers: [
					_CustomAppBar( title: movie.title, backdropPath: movie.fullBackdropPath),
					SliverList(
						delegate: SliverChildListDelegate([
							_PosterAndTitle(
								id: movie.heroId!,
								originalTitle: movie.originalTitle,
								title: movie.title,
								poster: movie.fullPosterImg,
								average: movie.voteAverage,
							),
							_Overview(
								textOverview: movie.overview
							),
							CastingCard( movieId: movie.id)
						])
					)
				],
			)
		);
	}
}

class _CustomAppBar extends StatelessWidget {
	final String backdropPath;
	final String title;

	const _CustomAppBar({
		Key? key, 
		required this.backdropPath, 
		required this.title
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SliverAppBar(
			backgroundColor: Colors.indigo,
			expandedHeight: 200,
			floating: false,
			pinned: true,
			flexibleSpace: FlexibleSpaceBar(
				centerTitle: true,
				titlePadding: const EdgeInsets.all(0),
				title: Container(
					width: double.infinity,
					color: Colors.black12,
					alignment: Alignment.bottomCenter,
					padding: const EdgeInsets.only( left: 10, right: 10, bottom: 10),
					child: Text(
						title,
						style: const TextStyle( fontSize: 16),
						textAlign: TextAlign.center,
					),
				),
				background: FadeInImage(
					placeholder: const AssetImage('assets/loading.gif'), 
					image: NetworkImage(backdropPath),
					fit: BoxFit.cover,
				),
			),
		);
	}
}

class _PosterAndTitle extends StatelessWidget {
	final String title;
	final String originalTitle;
	final String poster;
	final double average;
	final String id;

	const _PosterAndTitle({
		Key? key, 
		required this.title, 
		required this.originalTitle, 
		required this.poster, 
		required this.average, 
		required this.id
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {

		final TextTheme textTheme = Theme.of(context).textTheme;
		final size = MediaQuery.of(context).size;

		return Container(
			margin: const EdgeInsets.only( top: 20),
			padding: const EdgeInsets.symmetric( horizontal: 20),
			child: Row(
				children: [
					Hero(
						tag: id,
						child: ClipRRect(
							borderRadius: BorderRadius.circular(20),
							child: FadeInImage(
								placeholder: const AssetImage('assets/no-image.jpg'),
								image: NetworkImage(poster),
								height: 150,
							),
						),
					),
					const SizedBox( width: 20),
					ConstrainedBox(
						constraints: BoxConstraints( maxWidth: size.width - 190 ),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								//   ConstrainedBox(
								// 	  constraints: BoxConstraints( maxWidth: size.width - 190 ),
								// 	  child: Text( title, style: textTheme.headline6, overflow: TextOverflow.ellipsis, maxLines: 2)
								//   ),
								Text( title, style: textTheme.headline6, overflow: TextOverflow.ellipsis, maxLines: 2),
								Text( originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2),
								Row(
									children: [
										const Icon( Icons.star_outline, size: 15, color:  Colors.grey),
										const SizedBox( width: 5,),
										Text( average.toString(), style: textTheme.caption,)
									]
								)
							],
						),
					)
				]
			),
		);
	}
}


class _Overview extends StatelessWidget {
	final String textOverview;
	const _Overview({Key? key, required this.textOverview}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal:30, vertical: 10),
			child: Text(
				textOverview, 
				textAlign: TextAlign.justify,
				style: Theme.of(context).textTheme.subtitle1,
			),
		);
	}
}