// main.dart
// Aplicación web Flutter para gestión de inventario del supermercado.
// Contiene: modelo Producto, pantalla de lista y formulario.
// Autora: Danna Ramirez
// Programa: Análisis y Desarrollo de Software - SENA
// Evidencia: GA7-220501096-AA4-EV03

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELO: clase Producto
// Representa un producto del inventario con sus atributos.
// ─────────────────────────────────────────────────────────────────────────────
class Producto {
  int    id;
  String nombre;
  String categoria;
  double precio;
  int    cantidad;

  Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.cantidad,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PUNTO DE ENTRADA
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  runApp(const InventarioApp());
}

class InventarioApp extends StatelessWidget {
  const InventarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Supermercado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF37474F),
        ),
        useMaterial3: true,
      ),
      home: const PantallaInventario(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PANTALLA PRINCIPAL: lista de productos
// ─────────────────────────────────────────────────────────────────────────────
class PantallaInventario extends StatefulWidget {
  const PantallaInventario({super.key});

  @override
  State<PantallaInventario> createState() => _PantallaInventarioState();
}

class _PantallaInventarioState extends State<PantallaInventario> {

  // Lista de productos con datos de ejemplo
  final List<Producto> _productos = [
    Producto(id: 1, nombre: 'Arroz 1kg',       categoria: 'Granos',      precio: 2500, cantidad: 50),
    Producto(id: 2, nombre: 'Aceite 1L',        categoria: 'Aceites',     precio: 8900, cantidad: 30),
    Producto(id: 3, nombre: 'Leche 1L',         categoria: 'Lacteos',     precio: 3200, cantidad: 40),
    Producto(id: 4, nombre: 'Azucar 1kg',       categoria: 'Endulzantes', precio: 1800, cantidad: 60),
    Producto(id: 5, nombre: 'Papel Higienico',  categoria: 'Aseo',        precio: 4500, cantidad: 25),
  ];

  // Contador para asignar IDs a productos nuevos
  int _proximoId = 6;

  // ── ELIMINAR producto ────────────────────────────────────────────────────
  void _eliminarProducto(int id) {
    // Mostrar diálogo de confirmación antes de eliminar
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text('¿Está seguro que desea eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _productos.removeWhere((p) => p.id == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Producto eliminado')),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ── NAVEGAR al formulario para agregar o editar ───────────────────────────
  void _abrirFormulario({Producto? producto}) async {
    // Navegar a la pantalla del formulario y esperar el resultado
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaFormulario(producto: producto),
      ),
    );

    // Si el formulario retornó un producto, agregarlo o actualizarlo
    if (resultado != null) {
      setState(() {
        if (producto == null) {
          // Agregar nuevo producto
          resultado.id = _proximoId++;
          _productos.add(resultado);
        } else {
          // Actualizar producto existente
          final indice = _productos.indexWhere((p) => p.id == producto.id);
          if (indice != -1) {
            _productos[indice] = resultado;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Barra superior
      appBar: AppBar(
        title: const Text('Inventario Supermercado'),
        backgroundColor: const Color(0xFF37474F),
        foregroundColor: Colors.white,
      ),

      // Contenido: tabla de productos
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Título y botón agregar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lista de Productos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _abrirFormulario(),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar producto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37474F),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Mensaje si no hay productos
            if (_productos.isEmpty)
              const Center(child: Text('No hay productos registrados.'))

            // Tabla de productos
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(1.5),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(2),
                    },
                    children: [

                      // Encabezado de la tabla
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFF37474F),
                        ),
                        children: ['ID', 'Nombre', 'Categoría', 'Precio', 'Cantidad', 'Acciones']
                            .map((titulo) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    titulo,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),

                      // Filas de productos
                      ..._productos.asMap().entries.map((entrada) {
                        final indice = entrada.key;
                        final p = entrada.value;
                        final colorFila = indice % 2 == 0
                            ? Colors.white
                            : Colors.grey.shade50;

                        return TableRow(
                          decoration: BoxDecoration(color: colorFila),
                          children: [
                            // ID
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text('${p.id}'),
                            ),
                            // Nombre
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(p.nombre),
                            ),
                            // Categoría
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(p.categoria),
                            ),
                            // Precio
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text('\$${p.precio.toStringAsFixed(0)}'),
                            ),
                            // Cantidad
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text('${p.cantidad}'),
                            ),
                            // Botones editar y eliminar
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () => _abrirFormulario(producto: p),
                                    child: const Text('Editar'),
                                  ),
                                  TextButton(
                                    onPressed: () => _eliminarProducto(p.id),
                                    child: const Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PANTALLA FORMULARIO: agregar o editar producto
// Si recibe un producto, entra en modo edición con los datos pre-cargados.
// ─────────────────────────────────────────────────────────────────────────────
class PantallaFormulario extends StatefulWidget {
  final Producto? producto;

  const PantallaFormulario({super.key, this.producto});

  @override
  State<PantallaFormulario> createState() => _PantallaFormularioState();
}

class _PantallaFormularioState extends State<PantallaFormulario> {

  final _formKey       = GlobalKey<FormState>();
  final _nombreCtrl    = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _precioCtrl    = TextEditingController();
  final _cantidadCtrl  = TextEditingController();

  bool _esEdicion = false;

  @override
  void initState() {
    super.initState();
    // Si viene un producto, pre-llenar los campos
    if (widget.producto != null) {
      _esEdicion = true;
      _nombreCtrl.text    = widget.producto!.nombre;
      _categoriaCtrl.text = widget.producto!.categoria;
      _precioCtrl.text    = widget.producto!.precio.toString();
      _cantidadCtrl.text  = widget.producto!.cantidad.toString();
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _categoriaCtrl.dispose();
    _precioCtrl.dispose();
    _cantidadCtrl.dispose();
    super.dispose();
  }

  // Guardar y retornar el producto al padre
  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final producto = Producto(
      id:        widget.producto?.id ?? 0,
      nombre:    _nombreCtrl.text.trim(),
      categoria: _categoriaCtrl.text.trim(),
      precio:    double.parse(_precioCtrl.text),
      cantidad:  int.parse(_cantidadCtrl.text),
    );

    // Retornar el producto a la pantalla anterior
    Navigator.pop(context, producto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar Producto' : 'Agregar Producto'),
        backgroundColor: const Color(0xFF37474F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SizedBox(
          width: 460,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Campo: Nombre
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del producto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'El nombre no puede estar vacío' : null,
                  ),
                  const SizedBox(height: 14),

                  // Campo: Categoría
                  TextFormField(
                    controller: _categoriaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'La categoría no puede estar vacía' : null,
                  ),
                  const SizedBox(height: 14),

                  // Campo: Precio
                  TextFormField(
                    controller: _precioCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa el precio';
                      if (double.tryParse(v) == null) return 'Número inválido';
                      if (double.parse(v) < 0) return 'No puede ser negativo';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Campo: Cantidad
                  TextFormField(
                    controller: _cantidadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad en stock',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa la cantidad';
                      if (int.tryParse(v) == null) return 'Número entero inválido';
                      if (int.parse(v) < 0) return 'No puede ser negativa';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botones guardar y cancelar
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _guardar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF37474F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                        child: Text(_esEdicion
                            ? 'Actualizar producto'
                            : 'Guardar producto'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
