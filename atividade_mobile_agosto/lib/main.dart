import 'package:flutter/material.dart';

// Modelo de dados de um usuário
class Usuario {
  final String nome;
  final String email;

  Usuario({required this.nome, required this.email});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEV MOBILE - Cards',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100], // Fundo mais suave
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FormPage(),
        '/cards': (context) => CardsPage(),
      },
    );
  }
}

// ========================
// Tela de Formulário
// ========================
class FormPage extends StatefulWidget {
  FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';

  List<Usuario> usuarios = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Preencha os dados abaixo para adicionar um usuário",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person),
                ),
                onSaved: (value) => nome = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                onSaved: (value) => email = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Enviar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Usuario usuario = Usuario(nome: nome, email: email);
                    usuarios.add(usuario);
                    Navigator.pushNamed(
                      context,
                      '/cards',
                      arguments: usuarios,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================
// Tela de Cards
// ========================
class CardsPage extends StatelessWidget {
  CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarios =
        ModalRoute.of(context)!.settings.arguments as List<Usuario>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        centerTitle: true,
        elevation: 4,
      ),
      body: usuarios.isEmpty
          ? const Center(
              child: Text(
                'Nenhum usuário adicionado ainda.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Text(
                        usuario.nome.isNotEmpty
                            ? usuario.nome[0].toUpperCase()
                            : "?",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      usuario.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(usuario.email),
                  ),
                );
              },
            ),
    );
  }
}
