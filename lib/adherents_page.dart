import 'package:flutter/material.dart';

// Adhérent Model
class Adherent {
  final String nom;
  final String prenom;
  final String description;
  final String photo;

  Adherent({
    required this.nom,
    required this.prenom,
    required this.description,
    required this.photo,
  });
}

// Liste d'adhérents de test
List<Adherent> adherents = [
  Adherent(
    nom: 'Baraka',
    prenom: 'Obama',
    description: 'President.',
    photo: 'https://ygo-assets-entities-us.yougov.net/516e6836-d278-11ea-a709-979a0378f022.jpg?ph=528'
  ),
  Adherent(
    nom: 'George W. ',
    prenom: 'Bush',
    description: 'President.',
    photo: 'https://ygo-assets-entities-us.yougov.net/af46ff95-738d-11ea-affe-f9053ded7ac4.jpg?ph=528',
  ),
  Adherent(
    nom: 'Tom ',
    prenom: 'Cruise',
    description: 'Adherent Jeune.',
    photo: 'https://ygo-assets-entities-us.yougov.net/27ab2120-2d0d-11e6-8fa2-87887d182df9.jpg?ph=528',
  ),
];

// Écran de la liste des adhérents
class AdherentsPage extends StatefulWidget {
  const AdherentsPage({super.key});
  @override
  _AderentListScreenState createState() => _AderentListScreenState();
}

class _AderentListScreenState extends State<AdherentsPage> {
  List<Adherent> adherentsFiltered = [];

  @override
  void initState() {
    super.initState();
    adherentsFiltered = adherents;
  }

  void _filterAderents(String query) {
    setState(() {
      adherentsFiltered = adherents
          .where((adherent) =>
      adherent.nom.toLowerCase().contains(query.toLowerCase()) ||
          adherent.prenom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  void _deleteBook(int index) {
    // Confirm deletion with the user (optional)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le livre'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${adherentsFiltered[index].nom}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Remove the book from the list and update the UI
              setState(() {
                adherents.removeAt(adherents.indexOf(adherentsFiltered[index])); // Remove from original list as well
                adherentsFiltered.removeAt(index);
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
        title: Text('Liste des Adhérents'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _filterAderents(value),
              decoration: InputDecoration(
                labelText: 'Rechercher un adhérent',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: adherentsFiltered.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    adherentsFiltered[index].photo,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text('${adherentsFiltered[index].prenom} ${adherentsFiltered[index].nom}'),
                  subtitle: Text(adherentsFiltered[index].description),
                  onTap: () {
                    // Naviguer vers l'écran de détails de l'adhérent
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AderentDetailsScreen(adherent: adherentsFiltered[index]),
                      ),
                    );
                  }, trailing: IconButton(
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
          // Naviguer vers l'écran d'ajout d'adhérent
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAderentScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Écran de détails de l'adhérent
class AderentDetailsScreen extends StatelessWidget {
  final Adherent adherent;

  AderentDetailsScreen({required this.adherent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${adherent.prenom} ${adherent.nom}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                adherent.photo,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.0),
              Text(
                '${adherent.prenom} ${adherent.nom}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                adherent.description,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Écran d'ajout d'adhérent
class AddAderentScreen extends StatefulWidget {
  @override
  _AddAderentScreenState createState() => _AddAderentScreenState();
}

class _AddAderentScreenState extends State<AddAderentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _photoController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _descriptionController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un nouvel adhérent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un prénom';
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
                controller: _photoController,
                decoration: InputDecoration(
                  labelText: 'URL de la photo',
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
    // Ajoutez le nouvel adhérent à la liste
    final nouveauAderent = Adherent(
    nom: _nomController.text,
    prenom: _prenomController.text,
    description: _descriptionController.text,
    photo: _photoController.text,
    );

    // Ajoutez le code pour enregistrer le nouvel adhérent dans la source de données appropriée
    adherents.add(nouveauAderent);

    // Réinitialisez les champs du formulaire
    _nomController.clear();
    _prenomController.clear();
    _descriptionController.clear();
    _photoController.clear();

    // Affichez un message de succès ou naviguez vers l'écran de la liste des adhérents
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Adhérent ajouté avec succès'),
    ),
    );
    Navigator.pop(context);
    }
    },
      child: Text('Ajouter le Adhérent'),
    ),
    ],
    ),
    ),
        ),
    );
  }
}