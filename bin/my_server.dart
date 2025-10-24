import 'dart:async';

import 'package:socket_io/socket_io.dart';

void main() {
  final server = Server();

  server.on('connection', (client) {
    print('cliente conectado: $client');

    client.on('stream', (data) {
      print('Data recibida del cliente: ${client.id} , $data');
      client.broadcast.emit('stream', data);
    });

    Timer(Duration(seconds: 3), () {
      client.emit('msg', 'Bienvenido al Chat');
    });

    client.on('disconnect', (_) {
      print('cliente desconectado');
    });
  });

  server.listen(3005);
  print('Servidor socket, escuchando en el puerto 3005');
}
