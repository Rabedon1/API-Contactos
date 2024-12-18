import 'package:flutter/material.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> personas = [];

  @override
  void initState() {
    super.initState();
    cargarPersonas();
  }

  Future<void> cargarPersonas() async {
    try {
      final data = await apiService.obtenerPersonas();
      setState(() {
        personas = data;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void mostrarFormulario({Map<String, dynamic>? persona}) {
    final _formKey = GlobalKey<FormState>();
    final _nombreController = TextEditingController();
    final _apellidoController = TextEditingController();
    final _telefonoController = TextEditingController();

    if (persona != null) {
      _nombreController.text = persona['nombre'];
      _apellidoController.text = persona['apellido'];
      _telefonoController.text = persona['telefono'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            persona == null ? "Agregar Persona" : "Editar Persona",
            style: TextStyle(color: Colors.blueGrey),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Nombre", _nombreController),
                SizedBox(height: 10),
                _buildTextField("Apellido", _apellidoController),
                SizedBox(height: 10),
                _buildTextField("Teléfono", _telefonoController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 51, 202, 89),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(persona == null ? "Agregar" : "Guardar"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final nuevaPersona = {
                    "nombre": _nombreController.text,
                    "apellido": _apellidoController.text,
                    "telefono": _telefonoController.text,
                  };

                  if (persona == null) {
                    await apiService.crearPersona(nuevaPersona);
                  } else {
                    await apiService.actualizarPersona(persona['_id'], nuevaPersona);
                  }

                  cargarPersonas();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) =>
          value!.isEmpty ? "Por favor ingrese $label".toLowerCase() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Gestión de Personas"),
        backgroundColor: const Color.fromARGB(255, 93, 124, 139),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: personas.length,
          itemBuilder: (context, index) {
            final persona = personas[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueGrey[100],
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${persona['nombre']} ${persona['apellido']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Tel: ${persona['telefono']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => mostrarFormulario(persona: persona),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await apiService.eliminarPersona(persona['_id']);
                            cargarPersonas();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarFormulario(),
        backgroundColor: Colors.blueGrey[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
