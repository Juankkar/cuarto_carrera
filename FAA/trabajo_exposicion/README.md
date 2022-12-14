# Trabajo de exposición: Efecto de la consanguinidad en la resolución de problemas para *Mus musculus*

Este trabajo consistió en realizar una exposición de un diseño experimental. En nuestro caso, me encargué de la parte técnica, simulé un experimento con R.

Básicamente, consistió en... hipotéticamente hablando... aparear ratones (ojo ***hermanos***, importante para la discusión) en un nº de generaciones concreto (7 generaciones). Los cuales medíamos el tiempo que tardaban una serie de ratones consanguíneos con otros controles que no estaban emparentados y supuestamente sin endogamia.

La idea es que, a medida que los ratones tienen más generaciones de endogamia, más tardan en cruzar el laberinto.


## Simulación para sacar los datos.

El truco fue usar una función de R llamada ```sample()``` que puede coger valores aleatorios de una serie de intervalos que le asignes. Seguramente se puede hacer de una manera menos tediosa, pero vamos en su momento funcionó perfectamente. Este fue el código:

```
# # Simulación de los tiempos ratones endogámicos
generacion0 <- sample(245:300, 12, replace = TRUE) # Básicaente en este por ejemplo, da 12 ratones de 245 a 300 segundos con reemplazo
generacion1 <- sample(300:400, 12, replace = TRUE)
generacion2 <- sample(330:450, 12, replace = TRUE)
generacion3 <- sample(400:550, 12, replace = TRUE)
generacion4 <- sample(470:590, 12, replace = TRUE)
generacion5 <- sample(490:600, 12, replace = TRUE)
generacion6 <- sample(500:600, 12, replace = TRUE)
generacion7 <- sample(500:600, 12, replace = TRUE)
# 
# # Simulación de los ratones control
controles_0 <- sample(245:300, 12, replace = TRUE)
controles_1 <- sample(240:295, 12, replace = TRUE)
controles_2 <- sample(243:303, 12, replace = TRUE)
controles_3 <- sample(241:310, 12, replace = TRUE)
controles_4 <- sample(230:300, 12, replace = TRUE)
controles_5 <- sample(235:310, 12, replace = TRUE)
controles_6 <- sample(245:290, 12, replace = TRUE)
controles_7 <- sample(245:300, 12, replace = TRUE)
```

Un problema que pasa es que el código anterior cada vez que lo corras te va a salir un resultado algo distinto, ya que es aleatoria la función (aunque lo bueno es que de esta forma te da una simulación interesante). Lo repetí hasta un resultado que me gustó (todos son muy parecidos igualmente, el intervalo en el que están hacen que no cambien excesivamente), los voy a escribir en un archivo ```.csv``` que utilicé en su momento para la exposición, mediante la función ```write_csv()```. Lo haremos con el siguiente código:

```
# Creación de la base de datos
simulacion <- tibble(
  engdogamicos = c(generacion0,generacion1,generacion2,generacion3,
                   generacion4,generacion5,generacion6,generacion7),
  control = c(controles_0,controles_1,controles_2,controles_3,
              controles_4,controles_5,controles_6,controles_7)
  ) %>%
  mutate(generacion=c(rep("Generación 0", 12),rep("Generación 1", 12),rep("Generación 2", 12),
                      rep("Generación 3", 12),rep("Generación 4", 12),rep("Generación 5", 12),
                      rep("Generación 6", 12),rep("Generación 7", 12))) %>%
  pivot_longer(-generacion, names_to = "tratamiento", values_to = "resultados")

# Escribir los resulatdos en un csv
write_csv(simulacion, "simulacion_endogamia.csv") 
```

## Resultados elegidos para la exposición.

Después de una exploración de los datos, vimos que para todas las semanas, los resultados elegidos eran normales (alguno de ellos muy cerca de no serlo, pero normales). Para visualizarlos realizamos los siguientes histogramas:

---

<p align="center">
<img src="https://github.com/Juankkar/cuarto_carrera/blob/main/FAA/trabajo_exposicion/graficas/histogramas.png">
</p>

**Figura 1**: Histogramas para ver las distribuciones de los resultados, tanto para ratones control como para ratones endogámicos. Podemos ver que los ratones endogámicos cada generación que pasan, los tiempos se alejan más de los controles

---

Entonces los resutados del trabajo de una forma más clara estarían representados de la siguiente manera:

---

<p align="center">
<img src="https://github.com/Juankkar/cuarto_carrera/blob/main/FAA/trabajo_exposicion/graficas/endogamia.png" alt="700" width="700" />
</p>

**Figura 2.** Evolución de los ratones endogámicos y los ratones control. Vemos que estos últimos, el tiempo que tardan en el laberinto no se modifica, mientras que los ratones que presentan consanguinidad aumentan hasta un umbral de los 600 segundos en superar el laberinto.

---
### Comparación de los grupos
Realizamos en ese entonces inferencia estadística, está hecho para que independientemente del resultado, los ratones de la generación 0 no presenten diferencias significativas, por otro lado a partir de la primera, ya que consideramos que la endogamia entre hermanos aumenta rápidamente, ya los tiempos pasan a tener diferencias significativas. Estas se representaron en el gráfico con un **"*"**.

El umbral de los 600 segundos se debe a que los ratones llegan a la homocigosis.

Los modelos utilizados para comparar los grupos fueron la T-student para la mayoría de generaciones, excepto para las 2 y 7 que se realizó una T-Welch debido a la falta de homogeneidad de varianzas (la prueba de Levene fue significativa).

### Modelo predictivo: modelo de regresión lineal simple
Por último, realizamos un coeficiente de correlación de Pearson para ver si las variables de las generaciones pasadas y el tiempo que tardan los ratones endogámicos en cruzar el laberinto estaban relacionados linealmente.

* **Resultados de Pearson: estimación = 0.93, es próxima a 1, *p* < 0.05, la correlación es alta y se rechaza la hipótesis nula de que no existe correlación lineal entre las variables**

```
	Pearson's product-moment correlation

data:  simulación_regression$media_tiempo and simulación_regression$num_generacion
t = 6.3279, df = 6, p-value = 0.0007283
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.6647189 0.9879827
sample estimates:
      cor 
0.9325681 
```

* **Realizamos entonces el modelo de regresión lineal simple: p < 0.05, se rechaza la hipótesis nula de que el modelo no es predictivo, y sacamos los coeficientes de la recta**

```
Call:
lm(formula = media_tiempo ~ num_generacion, data = simulación_regression)

Residuals:
    Min      1Q  Median      3Q     Max 
-51.549 -17.678  -8.104  21.870  54.570 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)     313.326     27.039  11.588 2.49e-05 ***
num_generacion   40.901      6.464   6.328 0.000728 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 41.89 on 6 degrees of freedom
Multiple R-squared:  0.8697,	Adjusted R-squared:  0.848 
F-statistic: 40.04 on 1 and 6 DF,  p-value: 0.0007283
```

---

<p align="center">
<img src="https://github.com/Juankkar/cuarto_carrera/blob/main/FAA/trabajo_exposicion/graficas/Rplot09.png" alt="700" width=700/>
</p>

**Figura 3.** Resultados del modelo con la ecuación de la recta.

---

En la discusión de los resultados y conclusión habría que comentar los resultados como:

* **De esta manera, tenemos una ecuación la cual podríamos usar para predecir, a partir del tiempo que ha tardado un ratón de otro laboratorio trasladado al nuestro, cuanta endogamia tiene en número de generaciones. Esto podría intentar extrapolarse a otros tipos de animales.**

### OJO!!!, les gusta que le digas alguna posible aplicación o futuro proyecto que se puede sacar con estos resultados. Nosotros dijimos que se podría añadir un tercer grupo de estudio, cruce entre primos, para ver la respuesta a distintos niveles de consanguinidad. Nuestra hipótesis sería en ese entonces, que estos ratones también llegarían al umbral máximo de homocigosis, pero tardarían más número de generaciones en cuanto a cruces para ello.

Nada mal para haber salido de mi cabeza perturbada XD.


