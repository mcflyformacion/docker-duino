# 🚀 Duino-Coin Miner Docker Setup Script

Este repositorio contiene un script automatizado en Bash que facilita el despliegue de un contenedor Docker para minar [Duino-Coin](https://duinocoin.com). El script está optimizado para sistemas Ubuntu/Debian y se encarga de:

- Instalar `curl` y `Docker` si no están presentes.
- Descargar únicamente los archivos necesarios (`Dockerfile` y `docker-start.sh`) desde el repositorio original.
- Construir la imagen de Docker.
- Ejecutar el contenedor en segundo plano (modo **detached**) con los parámetros adecuados para minar.

---

## 🧩 Requisitos

- ✅ Sistema operativo **Ubuntu** o **Debian** (con privilegios de superusuario).
- ✅ Tener una [cuenta Duino-Coin](https://wallet.duinocoin.com/register.html).
- ✅ Docker y Curl (el script los instalará si no están presentes).
- ✅ Estar en el grupo `docker` para evitar permisos al ejecutar contenedores.

---

## 📁 Archivos que se descargan

El script descarga desde el repositorio de [simeononsecurity/docker-duino-coin](https://github.com/simeononsecurity/docker-duino-coin):

- [`Dockerfile`](https://github.com/simeononsecurity/docker-duino-coin/blob/main/Dockerfile)
- [`docker-start.sh`](https://github.com/simeononsecurity/docker-duino-coin/blob/main/docker-start.sh)

---

## ⚙️ Cómo usar

1. Clona este repositorio o descarga directamente el archivo `dunio.sh`.

2. Asigna permisos de ejecución al script:

```bash
chmod +x duino.sh
```

3. Ejecuta el script como superusuario:

```bash
sudo ./dunio.sh
```

🔐 **IMPORTANTE:** Antes de ejecutar, **edita el script** y cambia las siguientes variables de entorno con tus datos personales de Duino-Coin:

```bash
-e DUCO_USERNAME="<USUARIO DUINO>"
-e DUCO_MINING_KEY="<KEY DUINO>"
```

> Puedes encontrar tu `mining key` en el panel web de Duino-Coin.

---

## 🐳 Variables del contenedor Docker

Las variables de entorno utilizadas para configurar el minero dentro del contenedor son:

| Variable | Descripción |
|----------|-------------|
| `DUCO_USERNAME` | Tu nombre de usuario de Duino-Coin |
| `DUCO_MINING_KEY` | Tu clave personal de minería |
| `DUCO_INTENSITY` | Intensidad del minado (por defecto 50) |
| `DUCO_THREADS` | Número de hilos (por defecto 2) |
| `DUCO_START_DIFF` | Dificultad inicial (por defecto `MEDIUM`) |
| `DUCO_DONATE` | Porcentaje de donación al proyecto Duino-Coin |
| `DUCO_IDENTIFIER` | Identificador personalizado del dispositivo |
| `DUCO_ALGORITHM` | Algoritmo de minería (`DUCO-S1`) |
| `DUCO_LANGUAGE` | Idioma (por defecto `english`) |
| `DUCO_SOC_TIMEOUT`, `DUCO_REPORT_SEC`, `DUCO_RASPI_*`, `DUCO_DISCORD_RP` | Opciones adicionales de configuración |

---

## 📦 Resultado

Una vez finalizado el script:

- Se crea una imagen de Docker llamada `duinocoin`.
- Se lanza un contenedor llamado `duco-container` minando automáticamente Duino-Coin en segundo plano.

Puedes verificar que el contenedor está corriendo con:

```bash
docker ps
```

---

## 🧹 Para detener o eliminar el contenedor

```bash
docker stop duco-container
docker rm duco-container
```

---

## 📄 Licencia

Este proyecto es una adaptación del trabajo original de [simeononsecurity](https://github.com/simeononsecurity/docker-duino-coin) y se distribuye bajo la [Licencia MIT](LICENSE).
