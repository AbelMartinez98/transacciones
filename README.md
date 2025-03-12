# Transacciones App

Aplicación para gestionar transacciones financieras usando **Flutter** (Frontend) y **.NET** (Backend) con **SQL Server**.

---

## 📌 Requisitos previos

### Backend (.NET)

- .NET SDK 7+
- SQL Server
- Entity Framework Core

### Frontend (Flutter)

- Flutter SDK 3+
- Android Studio o VS Code con Flutter

---

## 🚀 Configuración y ejecución

### 1️⃣ Backend

1. **Configurar la base de datos**

   En el archivo `appsettings.json` del proyecto **Backend (.NET)**, configurar la cadena de conexión a SQL Server:

   ```json
   "ConnectionStrings": {
      "DefaultConnection": "Server=TU_SERVIDOR;Database=TransaccionesDB;User Id=sa;Password=TU_PASSWORD;TrustServerCertificate=True"
   }

2. **Ejecutar migraciones y actualizar la base de datos**

   En la terminal, dentro del proyecto .NET, ejecutar:

   ```
   dotnet ef database update

3. **Levantar el backend**

   ```
   dotnet ef database update

  **📌 Importante: La API se ejecutará en** http://0.0.0.0:5208

### 1️⃣ Frontend (Flutter)

1. **Configurar la URL del backend en `api_service.dart`**

   ```
   final String baseUrl = "http://TU_IP_LOCAL:5208/api";

2. **Instalar dependencias**

   ```
   flutter pub get

3. **Ejecutar la app**

   ```
   flutter run

## 📸 Video

Aquí el video demostrativo:

[Ver Video Demostrativo](demo_video.mp4)

   
