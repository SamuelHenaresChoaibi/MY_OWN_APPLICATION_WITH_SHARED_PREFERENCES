import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _numberController;
  String? _savedNumber; 

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _loadSavedNumber(); 
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedNumber = prefs.getString('saved_number');
      _numberController.text = _savedNumber ?? '';
    });
  }

  Future<void> _saveNumber() async {
    if (_numberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un número')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_number', _numberController.text);

      setState(() {
        _savedNumber = _numberController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número guardado exitosamente')),
      );

      Navigator.pushNamed(context, '/second');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Guardar número con Shared Preferences',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'Número guardado anteriormente:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                _savedNumber ?? 'Aún no hay número guardado',
                style: const TextStyle(color: Colors.yellow, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                'Ingresa un nuevo número:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: const OutlineInputBorder(),
                  hintText: 'Número',
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                ),
                onPressed: _saveNumber,
                child: const Text('Guardar y continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}