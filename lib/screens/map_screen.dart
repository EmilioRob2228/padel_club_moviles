import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:padel_club/config/firestore_sedes.dart';
import 'package:padel_club/models/sede_model.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const CameraPosition _celaya = CameraPosition(target: LatLng(20.5300, -100.8130), zoom: 12.5);

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> controller = Completer<GoogleMapController>();
    final firestoreSedes = FirestoreSedes();

    Future<void> irAMiUbicacion() async {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activa el permiso de ubicación para ver dónde estás')),
        );
        return;
      }
      final posicion = await Geolocator.getCurrentPosition();
      final mapa = await controller.future;
      await mapa.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(posicion.latitude, posicion.longitude), zoom: 14),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ubica tu sede')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreSedes.m_select(),
        builder: (context, snapshot) {
          final sedes = (snapshot.data?.docs ?? [])
              .map((doc) => SedeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();
          final marcadores = sedes
              .map(
                (sede) => Marker(
                  markerId: MarkerId(sede.id),
                  position: LatLng(sede.lat, sede.lng),
                  infoWindow: InfoWindow(
                    title: sede.nombre,
                    snippet: sede.direccion,
                    onTap: () => Navigator.pushNamed(context, '/sede', arguments: sede),
                  ),
                ),
              )
              .toSet();
          return GoogleMap(
            initialCameraPosition: _celaya,
            markers: marcadores,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (mapa) {
              if (!controller.isCompleted) controller.complete(mapa);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: irAMiUbicacion,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
