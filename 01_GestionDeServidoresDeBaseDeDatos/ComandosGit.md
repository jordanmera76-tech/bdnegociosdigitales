# Comandos Git

Primeros pasos

|  Comando                              | Descripcion |
|---------------------------------------|-----------------------------|
|git –version                           |Muestra la versión de GIT|
|git help                               |Muestra la ayuda de GIT |
|git help commit                        |Muestra ayuda sobre el comando |
|git config --global user.name “usuario”| Configura de forma global el usuario |
|git config  --global user.email “correo”|Establece de forma global el correo |
|git config --global core.editor “code  -- wait”|Establece como editor predeterminado a git visual studio code |
|git config --global -e                 |Lista todas las configuraciones globales|

## Comandos de git para un burn uso 

``` shell
git log
```
sirve para ver el historial de los ultimos cambios (commits) de un repositorio Git en cual te muwstra la fecha, el nombre del usuario 

``` shell
git status
``` 
Te muestra qué está pasando ahora mismo con tus archivos:
* Archivos modificados

* Archivos nuevos (no rastreados)

* Archivos listos para commit (staged)

* Si tu rama está actualizada o no

### Prepara los archivos para la actualizacion
* prepara todos los rachivos
``` shell
git add .     
``` 
* Prepapa el archivo especifico
``` shell
gti add nombre_del_archivo.ext
```
* Solo prepara los archivos actualizados (no archivos nuevos)
```  shell
git add -u
```
 este comado prepara los archivos para que puedan ser actualizados dependiendo que quieraz actualizar

### Guardado Oficial

``` shell
git commit -m  "Mensaje"
```
Este comando nso ayuda guardar los cambios que preparamos con aterioridad 

