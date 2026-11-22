import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FotoRed extends StatelessWidget {
  final String url;
  final double? alto;

  const FotoRed({super.key, required this.url, this.alto});

  @override
  Widget build(BuildContext context) {
    final fondo = Theme.of(context).colorScheme.surfaceContainerHighest;
    final vacio = Container(
      height: alto,
      color: fondo,
      child: Icon(Icons.sports_tennis, size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
    if (url.isEmpty) return vacio;
    return CachedNetworkImage(
      imageUrl: url,
      height: alto,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(height: alto, color: fondo),
      errorWidget: (context, url, error) => vacio,
    );
  }
}
