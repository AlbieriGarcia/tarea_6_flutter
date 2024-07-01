import 'package:flutter/material.dart';
import 'package:tarea_6/Pages.dart'; // Importa las páginas creadas en el paso anterior

class NavBar extends StatelessWidget {
  const NavBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Albieri Garcia'),
            accountEmail: const Text(''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://media.licdn.com/dms/image/D4E03AQGEMD9XYON3pQ/profile-displayphoto-shrink_800_800/0/1718212978156?e=1724284800&v=beta&t=TzZgPormlB_Trx-0R6dQON-HOll1DxqhYZvOsPUyR2U',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images7.alphacoders.com/126/thumb-1920-1266440.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_box_rounded),
            title: const Text('Adivinar Genero'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdivinarGenero()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_rounded),
            title: const Text('Adivinar Edad'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdivinarEdad()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_rounded),
            title: const Text('Buscar universidad'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuscarUniversidad()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_rounded),
            title: const Text('Clima en RD'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClimaEnRD()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_rounded),
            title: const Text('Pagina de WordPress'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaginaDeWordPress()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_rounded),
            title: const Text('Contactame'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Contactame()),
              );
            },
          )
        ],
      ),
    );
  }
}
