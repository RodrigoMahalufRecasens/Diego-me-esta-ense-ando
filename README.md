# uchile_system

## Overview

### Sobre uchile_system
...

### Actualizar la instalación

En caso de querer descargar repositorios faltantes o actualizar la instalación, siempre se puede correr el instalador nuevamente, sin miedo a romper lo que ya está funcionando. El único efecto adverso podría ser que los repositorios queden en la rama default, o commit default para el caso de los forks. Para eso, correr en un terminal:
```bash
# recordar des sourcear ROS y UChile ROS Framework desde ~/.bashrc
bash "$HOME"/uchile_ws/system/install/ws_installer.bash
```


## Instalación del sistema

*AVISO: Evitar copiar multiples líneas a la terminal, pues algunas podrían considerarse como argumento de las anteriores. Esto sucede, por ejemplo, cuando un script requiere input del usuario (contraseñas, aceptar/negar cosas...).*

Ejecutar en terminal (`Ctrl+Alt+T`)

### Pre-requisitos

#### Instalar ROS indigo

*AVISO: Esta sección se puede ignorar si es que ROS indigo ya está instalado en la máquina.*

```bash
# ROS Keys
# Evite instalar la versión full (sudo apt-get install ros-indigo-desktop-full) o alguna de las otras variantes.
# ver: http://wiki.ros.org/indigo/Installation/Ubuntu
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# actualizar base de software
sudo apt-get update

# instalar ROS base
sudo apt-get install ros-indigo-ros-base curl openssl pv python-rosinstall python-pip python-rosdep

# inicializar rosdep
sudo rosdep init # ignorar si es que falla con "ERROR: default sources list file already exists:..."
rosdep update    # NO EJECUTAR CON SUDO!
```

#### Instalar dependencias para system

```bash
sudo apt-get update
sudo apt-get install git python-flake8 shellcheck libxml2-utils python-yaml cppcheck curl openssl pv python-rosinstall python-pip openssh-client openssh-server python-rosdep
```


### Instalación de UChile ROS Framework

Procurar **ejecutar las veces que sea necesario**, pues puede fallar el clone de algún repositorio, por ejemplo, al introducir mal la clave.

*AVISO:* El instalador requiere no tener sourceado ROS en la consola actual ni en el archivo de configuración de bash. Para esto, debes asegurarte de que el archivo `~/.bashrc` no contenga líneas que hagan source de ROS ni de uchile_ws.

```bash
# descargar uch_system
git clone https://github.com/uchile-robotics/uchile_system.git ~/tmp_repo

# Obtener repositorios y crear workspaces
bash "$HOME"/tmp_repo/install/ws_installer.bash

# limpiar
rm -rf ~/tmp_repo
```

### Habilitar workspace para uso en consola

En cada caso puedes copiar el bloque de código directo en la terminal.

#### Sólo usuarios de bash

```bash
cat >> ~/.bashrc <<"EOF"

## -----------------------------------------------
## UCHILE ROS FRAMEWORK Settings

# workspace location
export UCHILE_WS="$HOME"/uchile_ws

# settings file location
export UCHILE_SHELL_CFG="$HOME"/uchile.sh

# UChile Robotics Framework for ZSH
# comment this line to prevent sourcing the framework
. "$UCHILE_WS"/system/setup.bash
## -----------------------------------------------

EOF
```

#### Sólo usuarios de zsh

```bash
cat >> ~/.zshrc <<"EOF"

## -----------------------------------------------
## UCHILE ROS FRAMEWORK Settings

# workspace location
export UCHILE_WS="$HOME"/uchile_ws

# settings file location
export UCHILE_SHELL_CFG="$HOME"/uchile.sh

# UChile Robotics Framework for ZSH
# comment this line to prevent sourcing the framework
. "$UCHILE_WS"/system/setup.zsh
## -----------------------------------------------

EOF
```

Al terminar la instalación debes reabrir el terminal.


## Configuraciones básicas

En el archivo `~/uchile.sh` se deben pueden configurar aspectos del framework como el robot a utilizar y opciones de red. Pon atención en las variables especificadas en tal archivo, pues deberás modificarlas constantemente.

Al menos, debieras configurar la variable de entorno `UCHILE_ROBOT`, que por defecto es `bender`. Ésta permite seleccionar que overlay de workspaces ROS se utilizarán. Todos los overlays diponibles se encuentran en el directorio `$UCHILE_WS/ros/`. Según el valor escogido, el workspace ROS linkeado proveerá distintos packages, y por lo tanto, requerirá distintos pasos de instalación.


## Configuraciones MUY recomendadas

Estas configuraciones son opcionales, pero se recomiendan para facilitar el desarrollo. Leer con atención y sólo habilitar las realmente deseadas.

Ejecutar en terminal (`Ctrl+Alt+T`)

```bash
# Usuario de Git y ~/.gitconfig global
# - provee usuario, mail, colores y aliases para comandos git.
# - tras copiar el .gitconfig, al menos se debe configurar "name" y "email"!!!
cp -bfS.bkp "$UCHILE_SYSTEM"/templates/default.gitconfig ~/.gitconfig
gedit ~/.gitconfig

# configurar ~/.bash_aliases: esto configura el prompt PS1 para git. 
cp -bfS.bkp "$UCHILE_SYSTEM"/templates/bash_aliases ~/.bash_aliases

# variable utilizada por "rosed" y algunos utilitarios de bender.
echo 'export EDITOR="gedit"' >> ~/.bashrc

# En orden:
# - agrega opción "abrir terminal" al click derecho
# - shell más moderno. permite subdivisiones en cada pestaña.
# - utilitario gráfico para git
sudo apt-get install nautilus-open-terminal terminator gitk

# Trabajar en rama "develop" de cada repositorio
# - si tras correr el comando algún repositorio no está en tal rama,
#   debes cambiarlo manualmente.
#   ej:
#   > cdb soft
#   > git checkout develop
bgit checkout develop

# Herramienta meld para git diffs. (OBS!, puede ser molesta para algunos!)
# - permite ver diffs más bellos.
# - descomentar línea [diff] external del .gitconfig.
sudo apt-get install meld
cp "$UCHILE_SYSTEM"/templates/gitconfig_meld_launcher.py ~/.gitconfig_meld_launcher.py
```


## Compilación de workspaces

En esta fase es importante el orden de compilación.

El sistema se divide en 5 workspaces, que en orden son: ROS, forks_ws, base_ws, soft_ws y high_ws.

Los pasos a seguir dependerán del robot a utilizar, según la variable `$UCHILE_ROBOT`. En caso de querer utilizar ambos robots, seguir todas las instrucciones. Si sólo se instalará para uno de los robots, seguir las instrucciones correspondientes.

Ejecutar lo siguiente en un nuevo terminal (`Ctrl+Alt+T`)

### Instalación de `forks_ws`

```bash
# instalar dependencias
cdb forks && cd .. && rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# Compilar
cdb forks && catkin_make
```

### Instalación de `base_ws`

#### base_ws (común)

```bash
# instalar dependencias
cdb base && rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# install uchile_turning_base
cdb uchile_turning_base  && bash install/install.sh
```

#### base_ws (sólo bender)

```bash
# install bender_description
cdb bender_description && bash install/install.sh
cdb bender_description && bash scripts/update_models.sh

# install bender_base
cdb bender_base && bash install/install.sh

# install bender_head
cdb bender_head && bash install/install.sh

# install bender_joy
cdb bender_joy && bash install/install.sh

# install bender_tts
cdb bender_tts && bash install/install.sh

# install bender_fieldbus
cdb bender_fieldbus && bash install/install.sh

# install bender_sensors
cdb bender_sensors && bash install/install.sh
```

#### base_ws (sólo maqui)

Nada que instalar aún!

#### base_ws (compilación - común)

```bash
cdb base && cd .. && catkin_make
```


### Instalación de `soft_ws`

#### soft_ws (común)

```bash
# instalar dependencias
cdb soft && rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# instalar dependencias de speech
cdb uchile_speech_pocketsphinx && bash install/install.sh
```

#### soft_ws (sólo bender)

```bash
# instalar dependencias de bender_arm_planning
cdb bender_arm_planning && bash install/install.sh

# instalar dependencias para deep learning
# [AVISO] puede tomar un par de horas !!
# [WARNING] Sólo testeado en consola bash. Puede haber problemas con pip. Ver: https://bitbucket.org/uchile-robotics-die/bender_system/issues/9/importerror-no-module-named
# [NOTA] No instalar no afecta en compilar bender
# cdb uchile_perception_utils && bash install/install.sh
```

#### soft_ws (sólo maqui)

Nada que instalar.

#### soft_ws (compilación - común)
 
```bash
cdb soft && cd .. && catkin_make
```

### Instalación de `high_ws`

#### high_ws (común)

```bash
# instalar dependencias
cdb high && rosdep install --from-paths . --ignore-src --rosdistro=indigo -y

# Compilar
cdb high && cd .. && catkin_make
```

### Configuración del simulador Gazebo

Para configurar una versión adecuada del simulador Gazebo debes seguir la documentación del package [bender_gazebo](https://github.com/uchile-robotics/uchile_system/wiki/bender_gazebo).
