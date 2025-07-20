import 'package:flutter/material.dart';
import 'package:ghibli/models/movie.dart';
import 'package:ghibli/services/movies_api_service.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class MovieWidget extends StatelessWidget {
  final String? id;

  const MovieWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: MoviesApiService().getMovieById(id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur lors du chargement du film'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('Aucun film trouvé'));
        }
        final movie = snapshot.data!;
        double rating = 0;
        if (movie.rtScore != null) {
          final score = double.tryParse(movie.rtScore!);
          if (score != null) {
            rating = (score / 20).clamp(0, 5); // Convertit 0-100 en 0-5
          }
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colonne gauche : image
                        Expanded(
                          flex: 1,
                          child: movie.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    movie.image!,
                                    fit: BoxFit.cover,
                                    height: 350,
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(width: 24),
                        // Colonne droite : infos
                        Expanded(
                          flex: 2,
                          child: _MovieDetails(movie: movie, rating: rating),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (movie.image != null)
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  movie.image!,
                                  fit: BoxFit.cover,
                                  height: 250,
                                ),
                              ),
                            ),
                          SizedBox(height: 16),
                          _MovieDetails(movie: movie, rating: rating),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final double rating;
  const _MovieDetails({required this.movie, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title ?? '', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        Text('Titre original : ${movie.originalTitle ?? ''}', style: Theme.of(context).textTheme.bodyLarge),
        Text('Romanisé : ${movie.originalTitleRomanised ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 12),
        RatingStars(
          value: rating,
          starCount: 5,
          starSize: 28,
          valueLabelVisibility: false,
        ),
        SizedBox(height: 12),
        Text(movie.description ?? '', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 16),
        Text('Réalisateur : ${movie.director ?? ''}'),
        Text('Producteur : ${movie.producer ?? ''}'),
        Text('Année de sortie : ${movie.releaseDate ?? ''}'),
        Text('Durée : ${movie.runningTime ?? ''} min'),
      ],
    );
  }
}
