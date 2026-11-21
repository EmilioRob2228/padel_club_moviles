import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarUsuario extends StatelessWidget {
  final String? fotoUrl;
  final String nombre;
  final double radio;

  const AvatarUsuario({super.key, required this.fotoUrl, required this.nombre, this.radio = 30});

  @override
  Widget build(BuildContext context) {
    final inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radio,
      backgroundImage: fotoUrl != null ? CachedNetworkImageProvider(fotoUrl!) : null,
      child: fotoUrl == null ? Text(inicial, style: TextStyle(fontSize: radio * 0.8)) : null,
    );
  }
}
