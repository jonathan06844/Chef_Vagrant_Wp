
unit_tests_on_vm() {
    # Obtener la ruta completa del ejecutable de Vagrant
    VAGRANT_CMD=$(which vagrant)

    # Verificar si se encontró el comando vagrant
    if [ -z "$VAGRANT_CMD" ]; then
        echo "No se encontró el comando vagrant en el sistema"
        exit 1
    fi

    # Verificar si el directorio de cookbooks existe
    COOKBOOKS_DIR="C:/Tarea/Chef_Vagrant_Wp/cookbooks"
    if [ ! -d "$COOKBOOKS_DIR" ]; then
        echo "El directorio de cookbooks '$COOKBOOKS_DIR' no existe"
        exit 1
    fi

    export TESTS=true

    echo -e "\n########## Ejecutando las pruebas unitarias en una VM ##########\n"

    # Iniciar la máquina virtual
    if ! "$VAGRANT_CMD" up; then
        echo "Error al iniciar la máquina virtual"
        exit 1
    fi

    # Esperar a que la máquina virtual se inicie completamente
    sleep 60

    # Ejecutar las pruebas en la máquina virtual
    for cookbook_dir in "$COOKBOOKS_DIR"/*; do
        cookbook_name=$(basename "$cookbook_dir")
        if [ -d "$cookbook_dir" ]; then
            echo "Ejecutando pruebas para el cookbook $cookbook_name"
            if ! "$VAGRANT_CMD" ssh -c "cd '/cookbooks/$cookbook_name' && chef exec rspec --format=documentation"; then
                echo "Error al ejecutar las pruebas para el cookbook $cookbook_name"
            fi
        fi
    done

    # Destruir la máquina virtual después de las pruebas
    if ! "$VAGRANT_CMD" destroy -f; then
        echo "Error al destruir la máquina virtual"
        exit 1
    fi

    unset TESTS

    echo -e "\n########## Fin de las pruebas unitarias en una VM ##########\n"
}



# Función para ejecutar pruebas en un contenedor Docker
unit_tests_on_container() {

    DOCKER_CMD=$(which docker)

    if [[ "$DOCKER_CMD" == "" ]]; then
        echo "Docker no encontrado"
        exit 1
    fi

    DOCKER_IMAGE="cppmx/chefdk:latest"
    TEST_CMD="chef exec rspec --format=documentation"

    echo -e "\n########## UnitTest en Docker ##########\n"

    $DOCKER_CMD run --rm -v $1:/cookbooks $DOCKER_IMAGE $TEST_CMD

    echo -e "\n########## Fin UnitTest en Docker ##########\n"
}

# ----------------------Función para ejecutar pruebas de integración e infraestructura

#!/bin/bash

function integration_tests() {
    local cookbooks_dir="C:/Tarea/Chef_Vagrant_Wp/cookbooks"
    local kitchen_path="C:/opscode/chef-workstation/bin/kitchen.bat"  # Ruta donde se encuentra kitchen

    # Agregar la ruta de kitchen al PATH
    export PATH="$kitchen_path:$PATH"

    echo -e "\n########## Running Integration Tests ##########\n"

    # Iterar sobre cada subdirectorio de cookbooks
    for cookbook_dir in "$cookbooks_dir"/*; do
        # Obtener el nombre del cookbook del directorio
        local cookbook_name=$(basename "$cookbook_dir")

        # Verificar si existe un archivo kitchen.yml en el directorio del cookbook
        if [ -f "$cookbook_dir/kitchen.yml" ]; then
            echo "Running tests for cookbook: $cookbook_name"
            sleep 5
            # Cambiar al directorio del cookbook
            cd "$cookbook_dir" || continue

            # Ejecutar las pruebas con Test Kitchen
            kitchen test
            sleep 5
            # Volver al directorio anterior
            cd - > /dev/null
        else
            echo "No kitchen.yml found for cookbook: $cookbook_name"
        fi
    done
    sleep 5
    echo -e "\n########## Integration Tests Finished ##########\n"
}

# Función principal para mostrar menú y opciones
main() {
    echo -e "\nElija una opción:\n"
    echo "1. Pruebas unitarias en Máquina Virtual (VM)"
    echo "2. Pruebas unitarias en Docker"
    echo "3. Pruebas de integración e infraestructura"
    echo "4. Salir"

    read -p "Opción: " OPTION

    case $OPTION in
        1) unit_tests_on_vm ;;
        2) unit_tests_on_container ;;
        3) integration_tests ;;
        4) echo -e "\n¡Hasta luego!\n" ; exit 0 ;;
        *) echo -e "\nOpción inválida. Saliendo...\n" ;;
    esac
}

# Ejecutar función principal
main