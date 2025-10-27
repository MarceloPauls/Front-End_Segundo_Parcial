# Sistema de Alquiler de Autos - TP Segundo Parcial

Este proyecto es el frontend para un sistema de alquiler de autos, desarrollado como Trabajo Práctico para el segundo parcial de la materia.

-   **Materia:** Electiva: Programación Web - Frontend 
-   **Profesor:** Ing. Gustavo Sosa Cataldo 
-   **Tecnología:** Flutter

---

## Equipo de Desarrollo

-   **Líder del Proyecto:** Marcelo Andre Pauls Toews
-   **(Integrante 2)**
-   **(Integrante 3)**
-   **(Integrante 4)**
-   **(Integrante 5)**

---

## Manual de Implementación (Despliegue)

Este manual detalla los pasos necesarios para descargar y ejecutar la aplicación en un entorno de desarrollo local.

### 1. Requisitos Previos

Antes de comenzar, asegúrese de tener instalado el siguiente software:

1.  **Flutter SDK:** (Instrucciones en [flutter.dev](https://flutter.dev/))
2.  **Git:** (Para clonar el repositorio)
3.  **Android Studio:** (Para el SDK de Android y el emulador)
    * *Importante:* Asegúrese de tener las **Android SDK Command-line Tools** instaladas a través del SDK Manager de Android Studio.
4.  **Un Editor de Código:** (Se recomienda VSCode con la extensión de Flutter)

### 2. Pasos para el Despliegue

#### Paso 1: Clonar el Repositorio

Abra una terminal y clone el repositorio desde GitHub/GitLab:

```bash
# Reemplace https://github.com/MarceloPauls/Front-End_Segundo_Parcial.git con la URL de su proyecto
git clone https://github.com/MarceloPauls/Front-End_Segundo_Parcial.git

#### Paso 2: Navegar a la Carpeta del Proyecto

Ingrese a la carpeta que se acaba de crear:
```bash
cd alquiler_autos_app

#### Paso 3: Instalar Dependencias
Flutter utiliza un archivo pubspec.yaml para gestionar los paquetes. Ejecute el siguiente comando para descargar las dependencias necesarias (como provider e intl):
```bash
flutter pub get
#### Paso 4: Preparar el Emulador (Versión Mobile)
Para cumplir con el requisito de "version mobile", la aplicación debe ejecutarse en un emulador de Android.

    Abra Android Studio.

    Vaya a Tools > Device Manager (Administrador de Dispositivos).

    Cree un nuevo dispositivo virtual (ej. Pixel 6) si aún no tiene uno.

    Inicie el emulador haciendo clic en el ícono de Play (▶) al lado de su dispositivo.

    Espere a que el teléfono virtual arranque por completo.
#### Paso 5: Ejecutar la Aplicación
Con el emulador ya encendido, regrese a su terminal (o la terminal integrada de VSCode) y ejecute:
```bash
flutter run
Flutter detectará automáticamente el emulador, compilará la aplicación y la instalará. La app se abrirá en el emulador una vez que el proceso finalice.