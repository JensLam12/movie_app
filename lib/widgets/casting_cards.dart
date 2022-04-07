import 'package:flutter/material.dart';

class CastingCard extends StatelessWidget {
	const CastingCard({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			height: 180,
			child: ListView.builder(
				itemCount: 10,
				scrollDirection: Axis.horizontal,
				itemBuilder: ( _, int index) => const _CastCard()
			),
		);
	}
}


class _CastCard extends StatelessWidget {
  const _CastCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
	return Container(
		margin: EdgeInsets.symmetric(horizontal: 10),
		width: 110,
		height: 100,
		child: Column(
			children: [
				ClipRRect(
					borderRadius: BorderRadius.circular(20),
					child: const FadeInImage(
						placeholder: AssetImage('assets/no-image.jpg'),
						image: NetworkImage('https://via.placeholder.com/300x4000'),
						height: 140,
						width: 100,
						fit: BoxFit.cover,
					),
				),
				const SizedBox(height: 5),
				const Text('actor.name', maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,)
			],
		),
	);
  }
}