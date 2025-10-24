import 'dart:async';
import 'dart:io';

import 'package:socket_io/socket_io.dart';

void main() {
  // Obtener puerto de las variables de entorno (Render lo asigna automáticamente)
  final port = int.parse(Platform.environment['PORT'] ?? '3005');

  final server = Server();

  server.on('connection', (client) {
    print('cliente conectado: ${client.id}');

    client.on('stream', (data) {
      print('Data recibida del cliente: ${client.id} , $data');
      client.broadcast.emit('stream', data);
    });

    Timer(Duration(seconds: 3), () {
      client.emit('msg', 'Bienvenido al Chat');
    });

    client.on('disconnect', (_) {
      print('cliente desconectado: ${client.id}');
    });
  });

  server.listen(port);
  print('🚀 Servidor socket escuchando en puerto $port');
}
