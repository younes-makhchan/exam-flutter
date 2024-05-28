import 'package:flutter/material.dart';

// Livre Model
class Livre {
  final String titre;
  final String auteur;
  final String description;
  final String couverture;

  Livre({
    required this.titre,
    required this.auteur,
    required this.description,
    required this.couverture,
  });
}

// Liste de livres de test

// Liste de livres de test
List<Livre> livres = [
  Livre(
    titre: 'The Little City',
    auteur: 'Marion',
    description: "A man sits in his modest, rundown house in Connecticut, missing his wife, who is working overseas as a governess to make money for the family. But he does have the companionship of his son, who supports him in his dreams of success as an inventor.",
    couverture: 'https://m.media-amazon.com/images/I/918SEApBbzL._SL1500_.jpg',
  ),
  Livre(
    titre: 'Chains of Gold',
    auteur: 'Nanncy',
    description: 'Cerilla, the sheltered, castle-bound protagonist of this inventive and moving fantasy novel, is determined to escape her bloody fate: marriage to a king who is to be sacrificed after she bears his child. But Cerilla makes the monumental mistake of falling in love with her god-like husband to be—Arlen of the Sacred Isle—and he with her. Arlens devoted comrade Lonn takes Arlens place so the lovers can flee. But their escape is just the beginning of an odyssey marked by struggle and hardship as they cope with hyperboreal storms,',
    couverture: 'https://m.media-amazon.com/images/I/91LRL8yOptL._SL1500_.jpg',
  ),
  Livre(
    titre: 'Riverworld and Other Stories',
    auteur: 'Phiilipe',
    description: 'On author Philip José Farmers Riverworld, humans from every era and culture have been simultaneously resurrected. Ancient Hebrews, medieval warriors, Spanish Inquisitors, and modern Americans intermingle in this strange new environment, but many still cling to old prejudices.',
  couverture: 'https://m.media-amazon.com/images/I/91YqH51NvIL._SL1500_.jpg',
  ),
];

// Écran de la liste des livres
class LivrePage extends StatefulWidget {
  const LivrePage({super.key});
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<LivrePage> {
  final searchController = TextEditingController();
  List<Livre> livresFiltered = [];

  @override
  void initState() {
    super.initState();
    livresFiltered = livres;
    searchController.addListener(_filterLivres);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterLivres() {
    final query = searchController.text.toLowerCase();
    setState(() {
      livresFiltered = livres.where((livre) {
        return livre.titre.toLowerCase().contains(query) ||
            livre.auteur.toLowerCase().contains(query);
      }).toList();
    });
  }
  void _deleteBook(int index) {
    // Confirm deletion with the user (optional)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le livre'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${livresFiltered[index].titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Remove the book from the list and update the UI
              setState(() {
                livres.removeAt(livres.indexOf(livresFiltered[index])); // Remove from original list as well
                livresFiltered.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Livres'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un livre',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: livresFiltered.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    livresFiltered[index].couverture,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text(livresFiltered[index].titre),
                  subtitle: Text(livresFiltered[index].auteur),
                  onTap: () {
                    // Naviguer vers l'écran de détails du livre
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookDetailsScreen(livre: livresFiltered[index]),
                      ),
                    );

                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Add functionality to delete the book
                      _deleteBook(index);
                    },
                  )
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers l'écran d'ajout de livre
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBookScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Écran de détails du livre
class BookDetailsScreen extends StatelessWidget {
  final Livre livre;

  BookDetailsScreen({required this.livre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(livre.titre),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                livre.couverture,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.0),
              Text(
                livre.titre,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Auteur: ${livre.auteur}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              Text(
                livre.description,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Écran d'ajout de livre
class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _auteurController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _couvertureController = TextEditingController();

  @override
  void dispose() {
    _titreController.dispose();
    _auteurController.dispose();
    _descriptionController.dispose();
    _couvertureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un nouveau livre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _auteurController,
                decoration: InputDecoration(
                  labelText: 'Auteur',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un auteur';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _couvertureController,
                decoration: InputDecoration(
                  labelText: 'URL de l\'image de couverture',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Ajoutez le nouveau livre à la liste
                    final nouveauLivre = Livre(
                      titre: _titreController.text,
                      auteur: _auteurController.text,
                      description: _descriptionController.text,
                      couverture: _couvertureController.text,
                    );

                    // Ajoutez le code pour enregistrer le nouveau livre dans la source de données appropriée
                    livres.add(nouveauLivre);

                    // Réinitialisez les champs du formulaire
                    _titreController.clear();
                    _auteurController.clear();
                    _descriptionController.clear();
                    _couvertureController.clear();

                    // Affichez un message de succès ou naviguez vers l'écran de la liste des livres
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Livre ajouté avec succès'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Ajouter le livre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}