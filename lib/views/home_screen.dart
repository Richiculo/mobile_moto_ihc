import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../models/pedido.dart';

class HomeScreen extends StatefulWidget {
  final String conductorId;

  const HomeScreen({super.key, required this.conductorId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  final ApiService _apiService = ApiService();

  // Ubicación del conductor
  LatLng _currentPosition = const LatLng(
    -17.783300,
    -63.182140,
  ); // Catedral por defecto
  Timer? _locationTimer;
  Timer? _pollingTimer;

  // Estado
  Pedido? _pedidoPendiente;
  bool _enServicio = false;

  @override
  void initState() {
    super.initState();
    _iniciarServicios();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _pollingTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _iniciarServicios() async {
    // Solicitar permisos de ubicación
    final permiso = await _solicitarPermisosUbicacion();
    if (!permiso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se requieren permisos de ubicación para usar la app'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Obtener ubicación inicial
    _obtenerUbicacionActual();

    // Enviar ubicación cada 5 segundos
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _obtenerUbicacionActual();
    });

    // Polling de pedidos cada 3 segundos
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _verificarPedidoPendiente();
    });
  }

  Future<bool> _solicitarPermisosUbicacion() async {
    // Verificar si ya tiene permisos
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    // Solicitar permisos
    if (status.isDenied) {
      status = await Permission.location.request();
    }

    // Si aún están denegados, pedir permisos en configuración
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  Future<void> _obtenerUbicacionActual() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
      await _enviarUbicacion();
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  Future<void> _enviarUbicacion() async {
    try {
      await _apiService.actualizarUbicacionConductor(
        widget.conductorId,
        _currentPosition.latitude,
        _currentPosition.longitude,
      );
    } catch (e) {
      print('Error enviando ubicación: $e');
    }
  }

  Future<void> _verificarPedidoPendiente() async {
    if (_enServicio) return; // Si ya está en servicio, no buscar nuevos

    try {
      final pedido = await _apiService.obtenerPedidoPendiente(
        widget.conductorId,
      );
      if (pedido != null && _pedidoPendiente == null) {
        setState(() {
          _pedidoPendiente = pedido;
        });
        _mostrarDialogPedido();
      }
    } catch (e) {
      print('Error verificando pedido: $e');
    }
  }

  void _mostrarDialogPedido() {
    if (_pedidoPendiente == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('¡Nuevo Pedido!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pedido: ${_pedidoPendiente!.id.substring(0, 8)}'),
                const SizedBox(height: 8),
                Text(
                  'Total: Bs. ${_pedidoPendiente!.total.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                Text('Dirección: ${_pedidoPendiente!.direccion}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => _rechazarPedido(),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Rechazar'),
              ),
              ElevatedButton(
                onPressed: () => _aceptarPedido(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D5F3F),
                ),
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  Future<void> _aceptarPedido() async {
    try {
      // Refrescar el pedido antes de aceptar para asegurar que los datos estén actualizados
      final pedidoActualizado = await _apiService.obtenerPedidoPendiente(
        widget.conductorId,
      );
      if (pedidoActualizado == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El pedido ya no está disponible')),
        );
        return;
      }

      setState(() {
        _pedidoPendiente = pedidoActualizado;
      });

      await _apiService.aceptarPedido(_pedidoPendiente!.id, widget.conductorId);
      setState(() {
        _enServicio = true;
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pedido aceptado')));
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _rechazarPedido() async {
    try {
      await _apiService.rechazarPedido(
        _pedidoPendiente!.id,
        widget.conductorId,
      );
      setState(() {
        _pedidoPendiente = null;
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pedido rechazado')));
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _iniciarViaje() async {
    try {
      await _apiService.iniciarViaje(_pedidoPendiente!.id, widget.conductorId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Viaje iniciado')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _entregarPedido() async {
    try {
      await _apiService.entregarPedido(
        _pedidoPendiente!.id,
        widget.conductorId,
      );
      setState(() {
        _pedidoPendiente = null;
        _enServicio = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido entregado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conductor: ${widget.conductorId}'),
        backgroundColor: const Color(0xFF0D5F3F),
      ),
      body: Stack(
        children: [
          // Mapa
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId('conductor'),
                position: _currentPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
            },
          ),

          // Panel de control (si hay pedido en servicio)
          if (_enServicio && _pedidoPendiente != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pedido: ${_pedidoPendiente!.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Dirección: ${_pedidoPendiente!.direccion}'),
                    Text(
                      'Total: Bs. ${_pedidoPendiente!.total.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _iniciarViaje,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5C842),
                              foregroundColor: const Color(0xFF0D5F3F),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Iniciar Viaje'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _entregarPedido,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D5F3F),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Entregar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
