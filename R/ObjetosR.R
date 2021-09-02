# OBJETOS
# vectores, matrices, data frames y listas

# vector
# es un conjunto de elementos simples del mismo tipo: caracteres, 
# números o strings. "Ahora no llueve" es una string.

v1 = c("a","b","c")
v2 = c(1,2,3)
v3 = 100:110
v2[3]
v1[-2]
v3[3:9]
v3[-c(3:9)]
letters
LETTERS
vl=letters
length(vl)
names(vl)
names(vl)= LETTERS
names(vl)
vl
vl[1] = "cualquier cosa"
vl
class(v1);class(v2)

# matriz
# es un vector de dos dimensiones: [fila,columna]
M = matrix(data = letters[1:12],nrow = 4, ncol = 3)
M
M[1,2]
M[1,]
M[,2]
M[,-2]
M
M[-2,-3]
M
t(M)
t(t(M))
identical(M,t(t(M)))
M==t(t(M))
# dos formas distintas de comprobar igualdad
M2= matrix(1:9,3)
M2
rowSums(M2)
colMeans(M2)
mean(M2)
sum(M2)
diag(M2)
det(M2)
M2**2 # no es el cuadrado de la matriz, sino los de cada elemento. 
#El cuadrado de la matriz sería 
M2%*%M2
# Aunque comviene instalar algún paquete que lo haga de forma más eficiente, o usar MatLab u Octave.
M
colnames(M) = c("C1","C2","C3")
M
rownames(M) = c("F1","F2","F3","F4")
M

# data frame
# Se parece a una matriz, pero tiene sus diferencias. Se la puede pensar como una hoja de cálculos
# o como una tabla de datos, con sus columnas (variables) y filas (casos)

a=letters[1:5]
b=LETTERS[6:10]
c=seq(from=1100,to=1500,by=100)  # se puede abreviar: seq(1000,1500,100)

DF=data.frame(a,b,c)
DF
# Se pueden «llamar» elementos o partes (filas, columnas, etc) igual que en matrices
DF[1,2]
DF[,2]
# pero también así:
DF$b
DF$c
DF$c[2]
dim(DF)
# 5 filas y 3 columnas
# si quiero agregar algo (válido también para vectores y matrices)
DF[,4] = 1:5
DF
# el nombre V4 se puso solo (variable 4), porque yo no le había
# asignado un nombre previamente; pero lo puedo cambiar también
colnames(DF)[4] = "d"
DF

M
M$C1 # ERROR
class(M)
MDF = as.data.frame(M)
MDF
class(MDF)
MDF$C1

write.table(MDF,file="MDF.tab",quote=FALSE)
tabla=read.table("MDF.tab",header=TRUE)
tabla
identical(tabla,MDF)

# pongan el help de read.table y miren, por arriba, cuántas posibilidades hay
?read.table


# lista
# Una lista puede imaginarse como un vector, pero en el que cada elemento puede
# ser cualquier cosa (otra lista, un número, una palabra, una matriz, etc)

lista = list(M,2,DF,letters)
lista
lista[[1]]
length(lista)
length(lista[[4]])

# puedo hacer listas con objetos del mismo tipo. Por ejemplo, hay un paquete llamado
# "seqinr" con un comando read.fasta, que lee un archivo fasta y lo convierte en una lista
# donde cada elemento es algo muy similar a un vector de caracteres (nucleótidos o aminoácidos)

# puedo fabricar, sin embargo, una "lista fasta", sin leerla, igual que hice con la data.frame.

bases= c("a","c","g","t")
cds1 = sample(bases, 300, replace = TRUE)
cds2 = sample(bases, 500, replace = TRUE)
cds3 = sample(bases, 450, replace = TRUE)
lista=list(cds1,cds2,cds3)
lista
length(lista)
length(lista[[1]])
sapply(lista, length)
lapply(lista,length)
# hacen lo mismo pero me devuelven los datos en distintos formatos
largos=c()
for(i in 1:length(lista)){
 largos[i]=length(lista[[i]])  
}
largos
# El sapply es, por lo tanto, un "loop for" de escritura abreviada.

# Ya que estoy, veremos algunas cosas que se pueden hacer con una secuencia
# sin recurrir a comandos predetermiandos

seq = cds1
seq
table(seq)
count(seq,wordsize = 1,start = 0,by = 1)
# parece más fácil usar "table", pero hay diferencias. Veamos:
seq2= c("a","c","t","t","t","c","a","a")
table(seq2)
count(seq2,1) # forma más abreviada, solo le di el wordsize, los demás están por defecto como quiero.
# count nos dice que encontró cero guaninas. ¿por qué? Porque la función count
# utiliza un alfabeto (por defecto, a, c, g, t) y cuenta eso y nada más que eso.


lista
length(lista)
seq3= c(seq2,"x","x")
seq3
table(seq3)
count(seq3,1,0)
# con "count" tambiéjn puiedo contar pares, tripletes, etc
count(seq,wordsize = 3, by = 1)
count(seq,wordsize = 2, by = 1)
count(seq,wordsize = 2, by = 2)
count(seq,wordsize = 5, by = 1, alphabet= "a")
seq= c("a","a","a","a","a","a","a")      
count(seq,wordsize = 3,by=1,alphabet="a")
count(seq,wordsize = 3,by=3,alphabet="a")
# Oberven qué cambió en la forma de usar count, y qué modificación produjo en el resultado.

cuenta=sapply(lista,table)
class(cuenta)
t(cuenta)  # así se entiende más
# Podremos hacer algo similar con count, pero debemos aprender a hacer funciones,
# porque sapply no admite funciones que precisan argumentos. O si no, usamos
# un loop for común y corriente.

cuentas= matrix(nrow=length(lista),ncol=4)
colnames(cuentas)= c("a","c","g","t")
cuentas
for(i in 1: length(lista)) {
  cuentas[i,] = count(lista[[i]],1)
}
cuentas
