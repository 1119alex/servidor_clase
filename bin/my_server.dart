import 'dart:async';
import 'dart:io';

import 'package:socket_io/socket_io.dart';

// Mapa para almacenar información de usuarios conectados
final Map<String, Map<String, String>> connectedUsers = {};
// socketId -> {'username': 'nombre', 'room': 'sala'}

void main() {
  // Obtener puerto de las variables de entorno (Render lo asigna automáticamente)
  final port = int.parse(Platform.environment['PORT'] ?? '3005');

  final server = Server();

  server.on('connection', (client) {
    print('📱 Cliente conectado: ${client.id}');

    // Evento: Establecer nombre de usuario
    client.on('set-username', (username) {
      if (connectedUsers[client.id] == null) {
        connectedUsers[client.id] = {};
      }
      connectedUsers[client.id]!['username'] = username;
      print('👤 Usuario ${username} identificado (${client.id})');
    });

    // Evento: Unirse a una sala
    client.on('join-room', (roomName) {
      // Guardar la sala del usuario
      if (connectedUsers[client.id] == null) {
        connectedUsers[client.id] = {};
      }
      connectedUsers[client.id]!['room'] = roomName;

      // Unir al cliente a la sala
      client.join(roomName);

      final username = connectedUsers[client.id]?['username'] ?? 'Anónimo';
      print('🚪 ${username} se unió a la sala: ${roomName}');

      // Confirmar al cliente que se unió a la sala
      client.emit('room-joined', roomName);

      // Notificar a otros en la sala
      client.to(roomName).emit('user-joined-room', {
        'username': username,
        'room': roomName,
      });
    });

    // Evento: Recibir y reenviar mensajes
    client.on('stream', (data) {
      final message = data['message'] ?? data;
      final username = data['username'] ?? connectedUsers[client.id]?['username'] ?? 'Anónimo';
      final room = data['room'] ?? connectedUsers[client.id]?['room'];

      print('💬 [${room ?? 'Sin sala'}] ${username}: ${message}');

      // Si hay sala, enviar solo a esa sala
      if (room != null) {
        client.to(room).emit('stream', {
          'message': message,
          'username': username,
          'room': room,
        });
      } else {
        // Si no hay sala, broadcast a todos
        client.broadcast.emit('stream', {
          'message': message,
          'username': username,
        });
      }
    });

    // Mensaje de bienvenida después de 3 segundos
    Timer(Duration(seconds: 3), () {
      final username = connectedUsers[client.id]?['username'] ?? 'Usuario';
      client.emit('msg', 'Bienvenido al Chat, ${username}!');
    });

    // Evento: Desconexión
    client.on('disconnect', (_) {
      final userData = connectedUsers[client.id];
      final username = userData?['username'] ?? 'Anónimo';
      final room = userData?['room'];

      print('👋 ${username} desconectado (${client.id})');

      // Notificar a la sala si estaba en una
      if (room != null) {
        client.to(room).emit('user-left-room', {
          'username': username,
          'room': room,
        });
      }

      // Eliminar usuario del mapa
      connectedUsers.remove(client.id);
    });
  });

  server.listen(port);
  print('🚀 Servidor socket escuchando en puerto $port');
  print('📊 Salas disponibles: General, Tecnología, Deportes, Música, Juegos, Películas');
}
