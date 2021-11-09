
# Sesgo en el uso de codones ----------------------------------------------


# Cargar la librería ------------------------------------------------------


library(seqinr)

# el archivo bicho1.ffn contiende CDS de una bacteria Veamos si dentro de de cada AA
# los codones sinónimos son usados con frecuencias similares.


# Leemos la secuencia de los CDS con read.fasta ---------------------------

fasta <- read.fasta("bicho1.ffn")

fasta_sin3 <- fasta[-which(getLength(fasta)%%3 >0)]
length(fasta) # El objeto fasta tiene 4319 secuencias (CDSs)


# Corroborar si el largo de todas las secuencias es múltiplo de 3 ---------
# Como se tratan de CDSs esperamos que todas las secuencias tengan largos múltiplos de 3, o sea, un número entero de codones.

# Largos de las secuencias: getLength

largos <- getLength(fasta)

# Otra forma: sapply

largos <- sapply(fasta, length)

# Calcular el módulo de los largos:

modulo <- largos%%3

# Si el modulo es igual a 0 el largo es múltiplo de 3, si es diferente de 0 el largo no es múltiplo de 3


# Eliminamos CDSs con módulos >0 ------------------------------------------

fasta_mult3 <- fasta[!modulo>0]

# Primero seleccionamos un CDS: el décimo ---------------------------------


f10 <- fasta_mult3[[10]]
f10


# Contamos los codones con count ------------------------------------------

cuenta10 <- count(f10, wordsize = 3, by = 3) # contamos palabras de a 3 letras, avanzando 3 posiciones a cada paso


# Obtenemos el número de codones de cada tipo con la función uco ----------

uco10 <- uco(f10)
cuenta10;uco10
identical(cuenta10,uco10)

# Es lo mismo hacer uco que count de a 3

# voy a ver a qué aminoácido corresponde cada codón -----------------------

names(uco10)
namesaa  <-  translate(sapply(names(uco10),s2c))

# Creamos el data frame df que tiene el codón, el conteo y el AA c --------

df <- as.data.frame(uco10)
df[,3] <- namesaa


# Ordenamos df por el AA (col 3) ------------------------------------------

df <- df[order(df[,3]),]

# con cex.names = 0.5 achicamos la letra de los nombres de las barras para que se vean todos

barplot(df$Freq,names.arg = df$V3, cex.names = 0.5)


# Voy a agregar una columna con los nombres de los AA ---------------------

df[,4] <- aaa(df[,3])


# Uso de codones para todos los CDS concatenados --------------------------


# Concatenar todos los CDSs -----------------------------------------------

sec <- unlist(fasta_mult3)
length(sec)
# Calcular número de codones ----------------------------------------------

ucosec <- uco(sec)


# Transformamos en data.frame y agregamos el AA codificado ----------------

df <- as.data.frame(ucosec)
df[,3] <- namesaa
df
df <- df[order(df[,3]),]

df[,4] <- aaa(df[,3]) 


# Hacemos un gráfico de barras con los conteos de codones -----------------

barplot(df$Freq, names.arg = df$V3, cex.names = 0.6)
