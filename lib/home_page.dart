import 'package:flutter/material.dart';
import 'livre_page.dart';
import 'adherents_page.dart';
import 'weather_page.dart';
import 'chatbot_page.dart';
import "about_page.dart";
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Home', style: TextStyle(color: Colors.blue, fontSize: 25)))),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage:AssetImage("assets/logo.jpg") , // replace with your logo URL
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Bibliothèque publique',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),

                ],
              ),
            ),
            ListTile(
              title: const Text('Home', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
              leading: const Icon(Icons.home),
            ),
            ListTile(
              title: const Text('Livres', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LivrePage()));
              },
              leading: const Icon(Icons.contacts),
            ),
            ListTile(
              title: const Text('Adherents', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdherentsPage()));
              },
              leading: const Icon(Icons.person),
            ),
            ListTile(
              title: const Text('Bibliotheque Chatbot', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBotPage()));
              },
              leading: const Icon(Icons.rocket),
            ),
            ListTile(
              title: const Text('Bibliotheque Meteo', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WeatherPage()));
              },
              leading: const Icon(Icons.cloud),
            ),
            ListTile(
              title: const Text('About', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
              },
              leading: const Icon(Icons.access_time_filled),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/logo.jpg',
              fit: BoxFit.cover,
              width: 50,
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Bienvenue à la Bibliothèque Publique ! Ici, vous pourrez découvrir une vaste collection de livres sur différents sujets.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}