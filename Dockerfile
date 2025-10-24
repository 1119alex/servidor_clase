# Usar imagen oficial de Dart
FROM dart:stable AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY pubspec.* ./

# Descargar dependencias
RUN dart pub get

# Copiar el resto del código
COPY . .

# Compilar la aplicación
RUN dart compile exe bin/my_server.dart -o bin/server

# Imagen final más ligera
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Exponer el puerto (Render usa la variable PORT)
EXPOSE 3005

# Ejecutar el servidor
CMD ["/app/bin/server"]
