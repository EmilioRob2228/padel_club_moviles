class Fechas {
  static const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  static const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];

  static String clave(DateTime fecha) {
    final m = fecha.month.toString().padLeft(2, '0');
    final d = fecha.day.toString().padLeft(2, '0');
    return '${fecha.year}-$m-$d';
  }

  static String legible(String clave) {
    final fecha = DateTime.parse(clave);
    return '${dias[fecha.weekday - 1]} ${fecha.day} ${meses[fecha.month - 1]}';
  }

  static String hora(int hora) => '${hora.toString().padLeft(2, '0')}:00';
}
