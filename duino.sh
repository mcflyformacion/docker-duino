#!/bin/bash

# Script optimizado para desplegar un contenedor Docker para minar Duino-Coin
# Descarga solo Dockerfile y docker-start.sh con curl, instala curl si no está presente, ejecuta en modo silencioso y detached

# Función para instalar curl en Ubuntu/Debian
install_curl() {
    apt-get update -qq
    apt-get install -y -qq curl
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

# Función para instalar Docker en Ubuntu/Debian
install_docker() {
    apt-get update -qq
    apt-get install -y -qq apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -qq
    apt-get install -y -qq docker-ce
    if [ $? -ne 0 ]; then
        exit 1
    fi
    systemctl start docker
    systemctl enable docker
}

# Verificar si curl está instalado
if ! command -v curl &> /dev/null; then
    install_curl
fi

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    if [[ -f /etc/lsb-release || -f /etc/debian_version ]]; then
        install_docker
    else
        exit 1
    fi
fi

# Verificar si el usuario está en el grupo docker
if ! groups $USER | grep -q docker; then
    usermod -aG docker $USER
    exit 1
fi

# Establecer directorio de trabajo
WORK_DIR="duino-coin"
IMAGE_NAME="duinocoin"
CONTAINER_NAME="duco-container"

# Eliminar directorio existente si está presente
if [ -d "$WORK_DIR" ]; then
    rm -rf $WORK_DIR
fi

# Crear directorio de trabajo
mkdir $WORK_DIR
cd $WORK_DIR

# Descargar solo los archivos necesarios
curl -s -O https://raw.githubusercontent.com/simeononsecurity/docker-duino-coin/main/Dockerfile
curl -s -O https://raw.githubusercontent.com/simeononsecurity/docker-duino-coin/main/docker-start.sh

# Verificar si el Dockerfile existe
if [ ! -f "Dockerfile" ]; then
    exit 1
fi

# Construir la imagen Docker
docker build -t $IMAGE_NAME . &> /dev/null
if [ $? -ne 0 ]; then
    exit 1
fi

# Detener y eliminar el contenedor si ya existe
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    docker stop $CONTAINER_NAME &> /dev/null
    docker rm $CONTAINER_NAME &> /dev/null
fi

# Ejecutar el contenedor en modo detached
docker run -d --name $CONTAINER_NAME --restart unless-stopped \
    -e DUCO_USERNAME="<USUARIO DUINO>" \
    -e DUCO_MINING_KEY="<KEY DUINO>" \
    -e DUCO_INTENSITY=50 \
    -e DUCO_THREADS=2 \
    -e DUCO_START_DIFF="MEDIUM" \
    -e DUCO_DONATE=0 \
    -e DUCO_IDENTIFIER="Auto" \
    -e DUCO_ALGORITHM="DUCO-S1" \
    -e DUCO_LANGUAGE="english" \
    -e DUCO_SOC_TIMEOUT=20 \
    -e DUCO_REPORT_SEC=300 \
    -e DUCO_RASPI_LEDS="n" \
    -e DUCO_RASPI_CPU_IOT="n" \
    -e DUCO_DISCORD_RP="n" \
    $IMAGE_NAME &> /dev/null
if [ $? -ne 0 ]; then
    exit 1
fi
