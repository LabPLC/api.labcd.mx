APIs del Laboratorio de Datos
=====

[![Build Status](https://travis-ci.org/LabPLC/api.labcd.mx.svg)](https://travis-ci.org/LabPLC/api.labcd.mx)

api.labcd.mx

##Dependencias
	gem install rails-api

##Instalación / Configuración
	Desde la terminal

	1.- $ git clone git@github.com:LabPLC/api.labcd.mx.git #clonar el repositorio 
    2.- $ rake bd:migrate #corremos las migraciones de la base de datos
    3.- $ rails bundle install #instalamos todas las gemas
    4.- $ bin/rails server
    5.- Acceder a localhost:3000


#### Las APIs del Laboratorio de Datos disponibles son:
* [Calidad del aire][aire]
* [Ecobici][ecobici]
* [Líneas de captura][lineas]
* [Pagos][pagos]
* [Taxis][taxis]
* [Vehículos][vehiculos]
* [Corralones][corralones]
* [Testamentos][testamentos]

[home]: https://github.com/LabPLC/api.labcd.mx/wiki
[aire]: https://github.com/LabPLC/api.labcd.mx/wiki/Calidad-del-Aire
[ecobici]: https://github.com/LabPLC/api.labcd.mx/wiki/Ecobici
[lineas]: https://github.com/LabPLC/api.labcd.mx/wiki/Lineas-de-captura
[pagos]: https://github.com/LabPLC/api.labcd.mx/wiki/Pagos
[taxis]: https://github.com/LabPLC/api.labcd.mx/wiki/Taxis
[vehiculos]: https://github.com/LabPLC/api.labcd.mx/wiki/Vehiculos
[corralones]: https://github.com/LabPLC/api.labcd.mx/wiki/Corralones
[testamentos]: https://github.com/LabPLC/api.labcd.mx/wiki/Testamentos

##¿Preguntas o problemas? 

Mantenemos la conversación del proyecto en nuestra página de problemas [issues] (https://github.com/LabPLC/api.labcd.mx/issues). Si usted tiene cualquier otra pregunta, nos puede contactar por correo <equipo@codeandomexico.org> o al Laboratirio para la ciudad con <daniel@labcd.mx>.

##¿Quiéres contribuir a las APIs?. Puedes colaborar con:
[código](https://github.com/LabPLC/api.labcd.mx/pulls),
[ideas](https://github.com/LabPLC/api.labcd.mx/issues) y 
[bugs](https://github.com/LabPLC/api.labcd.mx/issues). Lee el archvo [COLABORA](/CONTRIBUYE.md).

##Licencia

_Available under the license: GNU Affero General Public License (AGPL) v3.0. Read the document [LICENSE](/LICENSE) for more information_

Creado por [Codeando México](http://www.codeandomexico.org), 2014.
