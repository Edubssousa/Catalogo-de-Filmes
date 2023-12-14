import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Movie {
  final String title;
  final String director;
  final String imageUrl;

  Movie({
    required this.title,
    required this.director,
    required this.imageUrl,
  });
}

class LocalMovies {
  static List<Movie> getMovies(String category) {
    List<Movie> movies = [];

    for (int i = 1; i <= 30; i++) {
      movies.add(
        Movie(
          title: '$category Filme $i',
          director: 'Diretor $i',
          imageUrl: 'https://via.placeholder.com/150',
        ),
      );
    }

    return movies;
  }

  static void addMovie(String category, String title, String director, String imageUrl) {
    movies.add(
      Movie(
        title: title,
        director: director,
        imageUrl: imageUrl,
      ),
    );
  }

  static List<Movie> movies = [];
}

class PopularMovies {
  static List<Movie> getPopularMovies() {
    return [
      Movie(
        title: 'Filme Popular 1',
        director: 'Diretor Popular 1',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Movie(
        title: 'Filme Popular 2',
        director: 'Diretor Popular 2',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      // Adicione mais filmes populares conforme necessário
    ];
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // Adicionamos uma guia adicional para "Populares"
        child: Scaffold(
          appBar: AppBar(
            title: Text('Catálogo de Filmes'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Recomendados'),
                Tab(text: 'Família'),
                Tab(text: 'Populares'),
                Tab(text: 'Assistidos'),// Adicionamos uma guia para "Populares"
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: MovieSearchDelegate());
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              MovieList(category: 'recommended'),
              MovieList(category: 'family'),
              MovieList(category: 'popular'), // Adicionamos uma guia para "Populares"
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAddMovieDialog(context);
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void showAddMovieDialog(BuildContext context) {
    String title = '';
    String director = '';
    String imageUrl = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Filme'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Título'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Diretor'),
                onChanged: (value) {
                  director = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                onChanged: (value) {
                  imageUrl = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && director.isNotEmpty && imageUrl.isNotEmpty) {
                  LocalMovies.addMovie('user-added', title, director, imageUrl);
                  Navigator.of(context).pop();
                } else {
                  // Exiba uma mensagem ou lógica de validação adicional se necessário
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}

class MovieList extends StatelessWidget {
  final String category;

  MovieList({required this.category});

  @override
  Widget build(BuildContext context) {
    List<Movie> movies;

    if (category == 'popular') {
      movies = PopularMovies.getPopularMovies();
    } else {
      movies = LocalMovies.getMovies(category);
    }

    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieListItem(movie: movies[index]);
      },
    );
  }
}

class MovieListItem extends StatelessWidget {
  final Movie movie;

  MovieListItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(movie.title),
      subtitle: Text('Diretor: ${movie.director}'),
      leading: Image.network(movie.imageUrl),
      onTap: () {
        // Adicione ação ao tocar em um filme, se necessário
      },
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implemente a lógica para exibir os resultados da pesquisa
    // Por exemplo, você pode filtrar a lista de filmes com base na consulta de pesquisa
    List<Movie> searchResults = LocalMovies.movies
        .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return MovieListItem(movie: searchResults[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Pode ser implementado para exibir sugestões enquanto o usuário digita
    return Container();
  }
}
