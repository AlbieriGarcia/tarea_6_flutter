import 'package:flutter/material.dart';
import 'package:tarea_6/NavBar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

class AdivinarGenero extends StatefulWidget {
  const AdivinarGenero({Key? key}) : super(key: key);

  @override
  _AdivinarGeneroState createState() => _AdivinarGeneroState();
}

class _AdivinarGeneroState extends State<AdivinarGenero> {
  String nombre = ""; // Variable para almacenar el nombre ingresado
  String genero = ""; // Variable donde se guardará el género

  // Controlador para el campo de texto
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _obtenerGenero(String nombre) async {
    final response = await http.get(Uri.parse('https://api.genderize.io/?name=$nombre'));

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        genero = data['gender']; // Obtener el género del JSON
      });
    } else {
      throw Exception('Failed to load gender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Adivinar género'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40), // Espaciado horizontal
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Ingrese un nombre',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10), // Espaciado vertical
                ),
                onChanged: (value) {
                  nombre = value; // Actualizar el nombre mientras se escribe
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Llamar a la función para obtener el género
                _obtenerGenero(nombre);
              },
              child: Text('Adivinar género'),
            ),
            SizedBox(height: 20),
            genero == "male"
                ? Icon(Icons.sports_baseball, size: 100, color: Colors.blue)
                : genero == "female"
                    ? Icon(Icons.favorite, size: 100, color: Colors.pink)
                    : Container(), // Si no se reconoce el género, mostrar nada
          ],
        ),
      ),
    );
  }
}


class AdivinarEdad extends StatefulWidget {
  const AdivinarEdad({Key? key}) : super(key: key);

  @override
  _AdivinarEdadState createState() => _AdivinarEdadState();
}

class _AdivinarEdadState extends State<AdivinarEdad> {
  final TextEditingController _nameController = TextEditingController();
  String _ageCategory = '';
  int _age = 0;

  void _getAge(String name) async {
    final response = await http.get(Uri.parse('https://api.agify.io/?name=$name'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _age = data['age'] ?? 0;
        _determineAgeCategory(_age);
      });
    } else {
      // Si hay un error en la solicitud HTTP
      print('Error al obtener la edad.');
    }
  }

  void _determineAgeCategory(int age) {
    if (age < 20) {
      _ageCategory = 'Joven';
    } else if (age < 60) {
      _ageCategory = 'Adulto';
    } else {
      _ageCategory = 'Anciano';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Adivinar Edad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese un nombre',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  _getAge(name);
                }
              },
              child: const Text('Adivinar Edad'),
            ),
            const SizedBox(height: 20.0),
            if (_age > 0)
              Column(
                children: [
                  Text(
                    'La edad de ${_nameController.text} es $_age años.',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Categoría de edad: $_ageCategory',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  Image.asset(
                    _getImageForAgeCategory(_ageCategory),
                    height: 150,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getImageForAgeCategory(String category) {
    switch (category) {
      case 'Joven':
        return 'assets/images/joven.png';
      case 'Adulto':
        return 'assets/images/adulto.png';
      case 'Anciano':
        return 'assets/images/anciano.png';
      default:
        return 'assets/images/joven.png';
    }
  }
}


class BuscarUniversidad extends StatefulWidget {
  const BuscarUniversidad({Key? key}) : super(key: key);

  @override
  _BuscarUniversidadState createState() => _BuscarUniversidadState();
}

class _BuscarUniversidadState extends State<BuscarUniversidad> {
  TextEditingController _countryController = TextEditingController();
  List<dynamic> universities = [];
  bool isLoading = false;

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  Future<void> fetchUniversities(String countryName) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$countryName'));
      if (response.statusCode == 200) {
        setState(() {
          universities = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load universities: ${response.statusCode}');
        setState(() {
          isLoading = false;
          universities = [];
        });
      }
    } catch (e) {
      print('Error loading universities: $e');
      setState(() {
        isLoading = false;
        universities = [];
      });
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Buscar universidades por país'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _countryController,
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre del país (ej. Dominican Republic)',
                labelText: 'País',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String countryName = _countryController.text.trim();
              if (countryName.isNotEmpty) {
                fetchUniversities(countryName);
              }
            },
            child: const Text('Buscar'),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : universities.isEmpty
                    ? Center(child: Text('No se encontraron universidades'))
                    : ListView.builder(
                        itemCount: universities.length,
                        itemBuilder: (context, index) {
                          var university = universities[index];
                          return GestureDetector(
                            onTap: () {
                              String url = university['web_pages'].isEmpty ? '' : university['web_pages'][0];
                              if (url.isNotEmpty) {
                                _launchURL(url);
                              }
                            },
                            child: ListTile(
                              title: Text(university['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dominio: ${university['domains'].isEmpty ? 'No disponible' : university['domains'][0]}'),
                                  Text('Página web: ${university['web_pages'].isEmpty ? 'No disponible' : university['web_pages'][0]}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class ClimaEnRD extends StatefulWidget {
  const ClimaEnRD({Key? key}) : super(key: key);

  @override
  _ClimaEnRDState createState() => _ClimaEnRDState();
}

class _ClimaEnRDState extends State<ClimaEnRD> {
  // Variables para almacenar la información del clima
  String ciudad = 'Santo Domingo';
  double temperatura = 0.0;
  String descripcion = '';
  int humedad = 0;
  double velocidadViento = 0.0;
  String icono = '';

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener el clima actual
    obtenerClima();
  }

  Future<void> obtenerClima() async {
    // URL de la API con tu latitud y longitud
    String url = 'http://api.openweathermap.org/data/2.5/forecast?lat=18.47186&lon=-69.89232&appid=3d8134cc2bb368f5f94b3e889ddcda05';

    // Realizar la petición GET
    http.Response response = await http.get(Uri.parse(url));

    // Decodificar la respuesta JSON
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Obtener el clima actual del primer elemento de 'list' (que corresponde al primer período del día)
      var climaActual = data['list'][0];

      // Extraer los datos relevantes
      setState(() {
        ciudad = 'Santo Domingo'; // Puedes cambiar esto si tienes más ciudades
        temperatura = climaActual['main']['temp'];
        descripcion = climaActual['weather'][0]['description'];
        humedad = climaActual['main']['humidity'];
        velocidadViento = climaActual['wind']['speed'];
        icono = climaActual['weather'][0]['icon'];
      });
    } else {
      // Si hay un error en la solicitud HTTP
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Clima en RD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ciudad: $ciudad',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Temperatura: ${temperatura.toStringAsFixed(1)} °C',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Descripción: $descripcion',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Humedad: $humedad%',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Velocidad del viento: ${velocidadViento.toStringAsFixed(1)} m/s',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // Mostrar el icono correspondiente al clima actual
            icono.isNotEmpty
                ? Image.network('http://openweathermap.org/img/w/$icono.png')
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordPress News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaginaDeWordPress(),
    );
  }
}

class PaginaDeWordPress extends StatefulWidget {
  const PaginaDeWordPress({Key? key}) : super(key: key);

  @override
  State<PaginaDeWordPress> createState() => _PaginaDeWordPressState();
}

class _PaginaDeWordPressState extends State<PaginaDeWordPress> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://fortune.com/wp-json/wp/v2/posts'));
    if (response.statusCode == 200) {
      setState(() {
        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
        posts = parsed.map<Post>((json) => Post.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('WordPress News'),
      ),
      body: posts != null
          ? ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].excerpt),
                  onTap: () {
                    // Navegar a la URL original del post
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WebViewPage(posts[index].link)),
                    );
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class Post {
  final String title;
  final String excerpt;
  final String link;

  Post({
    required this.title,
    required this.excerpt,
    required this.link,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title']['rendered'],
      excerpt: json['excerpt']['rendered'],
      link: json['link'],
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Noticia'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}


class Contactame extends StatelessWidget {
  const Contactame({Key? key}) : super(key: key);

 Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Contactame'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen circular
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  'https://media.licdn.com/dms/image/D4E03AQGEMD9XYON3pQ/profile-displayphoto-shrink_800_800/0/1718212978156?e=1724284800&v=beta&t=TzZgPormlB_Trx-0R6dQON-HOll1DxqhYZvOsPUyR2U',
                ),
              ),
              SizedBox(height: 20.0),
              // Nombre
              Text(
                'Albieri Garcia',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Centrado del texto
              ),
              SizedBox(height: 10.0),
              // Correo electrónico centrado
              Text(
                'albieri404@gmail.com',
                textAlign: TextAlign.center, // Centrado del texto
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              // Teléfono centrado
              Text(
                'Teléfono: 829-864-6868',
                textAlign: TextAlign.center, // Centrado del texto
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

}