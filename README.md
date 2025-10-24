# Servidor Socket.IO - Chat en Tiempo Real

Servidor WebSocket construido con Dart y Socket.IO para aplicación de chat en tiempo real.

## Características

- ✅ Conexiones WebSocket en tiempo real
- ✅ Broadcast de mensajes a todos los clientes conectados
- ✅ Mensaje de bienvenida automático
- ✅ Preparado para deploy en Render.com
- ✅ Puerto dinámico (configurable por variable de entorno)

## Ejecutar localmente

```bash
dart pub get
dart run bin/my_server.dart
```

El servidor escuchará en `http://localhost:3005`

## Deploy en Render

1. Sube este código a GitHub
2. Conecta el repositorio en Render.com
3. Render detectará automáticamente el Dockerfile
4. El servidor se desplegará automáticamente

## Variables de entorno

- `PORT`: Puerto donde escuchará el servidor (Render lo asigna automáticamente)
