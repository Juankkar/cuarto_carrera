# Prácticas de los tenebrios. (Sacamos un 9.5) 

## Información sobre las prácticas.

* Durante el primer cuatrimestre tuvimos que cuidar a unas larvas de esta especie de escarabajos.
* Cada semana había que visitar los laboratorios del Área de Fisiología Animal, donde tomábamos las medidas del aumento de la masa corporal.

### Objetivos de las prácticas.

* A partir de la toma de la masa corporal de unas 12 larvas originales:
	* En una práctica de informática te enseñarán como tomar los datos en Excel. El objetivo principal de la práctica es aprender, además de como tomar los datos de la masa corporal, sacar a partir de ella la tasa de crecimiento, que se hace básicamente, por ejemplo, restanto la masa corporal de la 1º semana con la siguiente, es decir, de la 2º ( es decir, masa corporal 2º semana - masa corporal 1º semana), así hasta la última semana. Por eso mismo, la gracia de la práctica es aprender a como automatizar el proceso en Excel, o en mi caso en R (este no te lo enseñan obvio xd). Luego la tasa de crecimiento diaria es obviamente la semanal/7 días.
	* El experimento dura hasta que el 50% de tus larvas se convierten en pupa. 
	* Una vez que todos los grupos finalicen, además de analizar tus datos, hay que hacerlo del resto.

La verdad es que una práctica muy interactiva, a mí me gustó mucho

### Vamos, en resumen hay que:
* Realizar una memoria de tus datos y la de tus compañeros estudiando las siguientes variables...
	* Masa Corporal: aumento del peso semanal.
	* Tasa de crecimiento semanal: lo que han crecido en la semana
	* Tasa de crecimiento diaria: lo que han crecido diariamente

## En ese sentido, en este directorio tengo:

* ***Dos scripts:*** 

	* ```tenebrios.R``` con los resultados del nuestro grupo, es decir, el Grupo 4 de Oscuridad. 

	* Por otro lado, el script de ```tene_todos_limpio.R``` es el que utilicé para estudiar los resultados de todos los grupos.

* ***Tres bases de datos:***

	* Nuestros resultados: están por un lado: ```tenebrios.csv``` --> tal cuál como te piden hacer la base de datos (la media de la masa corporal cada semana), las tasas de crecimiento semanal y diaria. Mientras, ```df_tenebrios.csv```, los datos de cada uno de los tenebrios pesados cada semana, es decir, nuestros resultados en crudo.

	* Resultados de todos: La base de datos de todos los alumnos de FAA del año 2021-22. He de decir que la forma que toman los datos, queda muy bonito, pero no es muy R, SPSS, Python... friendly, con lo cual tuve que hacer un preprocesamiento guapo. 


