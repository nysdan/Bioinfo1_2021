# En principio, un dotplot es un gráfico en el que pongo una secuencia
#en el eje x y otra en el eje y, y marco con un punto las coincidencias. 
# O puede ser un 1 para las coincidencias y un 0 para las discrepancias, 
#o como se les ocurra. Aquí uso 1 para coincidencias, y (.) para las no 
# coincidencias. Las secuencias son ACBD y ABCD.


# D . . . 1
# C . 1 . .
# B . . 1 .
# A 1 . . .
#   A C B D

# hacer a mano dotplots con las primeras diez letras del alfabeto donde aparezcan:
# 1) una mutación
# 2) una inserción/deleción
# 3) una inversión (en una secuencia, con respecto a la otra) de tres letras
# 4) una subsecuencia repetida en una de las dos secuencias
# 5) la secuencia que tiene el repetido contra sí misma


# Ahora con secuencias de ADN
# a) una secuencia de adn de 10 letras contra sí misma
# b) imaginar que, para evitar tanto ruido, exigimos (para marcar un punto) que esa y la siguiente letras coincidan.
# c) ¿qué pasa si aumentamos el tamaño de ventana?
# d) ¿Y si aumentamos la ventana pero permitimos algún missmatch por ventana?


# entrar a R e importar el paquete seqinr
library(seqinr)

# Vamos a levantar dos secuencias que están ya, en R, como muestra

aafile <- system.file("sequences/seqAA.fasta", package ="seqinr")
dnafile <- system.file("sequences/malM.fasta", package ="seqinr")

AA<-read.fasta(aafile)
NN<-read.fasta(dnafile)
aa <- AA[[1]]
nn <- NN[[1]]

# Ahora vean el help de la función dotPlot. 
?dotPlot
# o si no
help(dotPlot)


# hagan un dotplot de nn contra sí misma, y lo mismo para aa.
# ¿Por qué nn tiene tanto más ruido que aa?
# ¿Cómo podemos eliminarlo usando los demás parámetros de la función dotPlot?

# Lean bien qué quieren decir los parámetros.




dotPlot(nn,nn)
dotPlot(aa,aa)
dotPlot(nn,nn,wsize = 8, wstep = 8, nmatch = 8)

# vamos a modificar nn, sustituyendo más o menos un 10% de las bases, y probar
length(nn)
bases= s2c("acgt")
sitios = sample(1:921,123)
nn2 = nn
nn2[sitios] = sample(bases,123,replace=TRUE)
# O sea, elegí 92 sitios al azar, y los remplacé en nn2 (que originalmente es igual
# a nn) por 120 bases al azar. De esos 123 sitios, 1/4 no cambiarán, con lo que 
# cambiarán en realidad unos 123-123/4 = 92.25, o sea, aproximadamente el 10% de 921


table(nn)
table(nn2)

dotPlot(nn,nn2)
dotPlot(nn,nn2,wsize = 4, wstep = 4, nmatch = 4)
dotPlot(nn,nn2,wsize = 4, wstep = 4, nmatch = 3)
dotPlot(nn,nn2,wsize = 5, wstep = 5, nmatch = 5)
dotPlot(nn,nn2,wsize = 5, wstep = 5, nmatch = 4)
dotPlot(nn,nn2,wsize = 6, wstep = 4, nmatch = 5)
