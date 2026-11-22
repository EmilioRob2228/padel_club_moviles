import 'package:local_auth/local_auth.dart';

class Huella {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<String?> m_autenticar(String motivo) async {
    try {
      final soportado = await _auth.isDeviceSupported();
      final biometria = await _auth.canCheckBiometrics;
      if (!soportado || !biometria) {
        return 'Configura una huella o Face ID en el dispositivo para continuar';
      }
      final valido = await _auth.authenticate(localizedReason: motivo);
      return valido ? null : 'cancelado';
    } catch (e) {
      return 'No se pudo verificar la huella';
    }
  }
}
