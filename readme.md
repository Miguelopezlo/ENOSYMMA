# Sprints

1. Epics Documentación
2. Epics Recopilación de información
3. Epics Análisis Datos
4. Epics Reporte resultados

# GEOENOS

GEOENOS is an easy-to-use app that tracks the impacts of El Niño-Southern Oscillation (ENSO) on rainfall and landslides. It provides forecasts, risk assessments, and alerts to help users understand and respond to the changes caused by ENSO extremes. Whether you’re a researcher or just looking to stay informed, ENOSWatch keeps you prepared for climate-related risks.

## Características

- Configuración básica de una aplicación

## Requisitos previos

- Docker y Docker Compose instalados en tu máquina. Preferiblemente con [docker desktop](https://www.docker.com/products/docker-desktop/)
- [pyenv](https://github.com/pyenv/pyenv#installation) o [pyenv-win](https://github.com/pyenv-win/pyenv-win#quick-start)
- [poetry](https://python-poetry.org/docs/#installation)


## Pasos iniciales

* Clona este repositorio:

```bash
git clone https://github.com/.../GeoEnos.git
cd template_fastAPI_mongodb
```
* Crea un archivo .env en la raíz del proyecto con las siguientes variables:

```text
ENVIRONMENT=
DEBUG=

```

## Instalación con Docker <!-- TODO[x]: Contenerizer that's app -->
es el modo fácil de levantar el proyecto
```bash
docker compose --profile web  build
docker compose --profile web  up
```
## Instalación con pyenv y poetry
es el modo difícil  de levantar el proyecto  pero nos sirve para habilitar las opciones de debug mas fácil. recuerde instalar un motor de mongo para la bd.
```bash
pyenv versions #opcional: sirve para comprobar si la version de python que necesitamos ya se encuentra descargada
pyenv install --list #opcional: sirve para listar los versiones disponible por pyenv
pyenv install 3.10.12  #Python Version supported in colaboratory
```

```bash
poetry --version
poetry env info
poetry env use $(pyenv which python)
poetry env info # la version de python debe coincidir 
poetry shell
poetry install
poetry show # dependencias instaladas == pip list
poetry add [dependecias]
```
🚫 :sos: Si al realizar la instalación de las dependencia se presenta un error. Eliminar el archivo poetry.lock y ejecutar el siguiente comando

```bash
poetry lock --no-update
```

```bash
ruff format   /Users/chocoplot/Documents/CodeLab/PYTHON/GeoENOS/src/GeoEnos_Lab_data.ipynb
nbqa ruff --fix  /Users/chocoplot/Documents/CodeLab/PYTHON/GeoENOS/src/GeoEnos_Lab_data.ipynb
python -m jupyter nbconvert ./src/GeoEnos_Lab_data.ipynb --to pdf --output export.pdf
```
