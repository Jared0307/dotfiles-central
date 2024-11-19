#!/bin/bash

# Colores para mensajes
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${GREEN}Iniciando la instalación de dotfiles desde el repositorio central...${RESET}"

# Repositorios de dotfiles
repos=(
    "https://github.com/Jared0307/dotfiles.git"
    # Agrega más repositorios aquí si es necesario
)

# Directorio temporal para clonar repositorios
temp_dir=$(mktemp -d)
echo -e "${GREEN}Directorio temporal creado: $temp_dir${RESET}"

# Función para manejar errores
error() {
    echo -e "${RED}Error: $1${RESET}"
    exit 1
}

# Iterar sobre los repositorios e instalar
for repo in "${repos[@]}"; do
    echo -e "${GREEN}Clonando el repositorio: $repo${RESET}"
    git clone "$repo" "$temp_dir/repo" || error "No se pudo clonar el repositorio $repo"

    # Entrar al repositorio clonado
    cd "$temp_dir/repo" || error "No se pudo acceder al directorio del repositorio"

    # Dar permisos y ejecutar el script de instalación
    if [[ -f "RiceInstaller" ]]; then
        chmod +x RiceInstaller || error "No se pudo cambiar permisos a RiceInstaller"
        echo -e "${GREEN}Ejecutando RiceInstaller...${RESET}"
        ./RiceInstaller || error "Fallo al ejecutar RiceInstaller"
    else
        echo -e "${RED}RiceInstaller no encontrado en el repositorio $repo${RESET}"
    fi

    # Volver al directorio original
    cd - > /dev/null || exit
done

# Limpieza
rm -rf "$temp_dir"
echo -e "${GREEN}Todos los dotfiles han sido instalados correctamente.${RESET}"

exit 0
