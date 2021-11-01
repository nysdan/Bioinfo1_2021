# Usaremos
# CP007025.gbk
# Es un archivo.gbk (de "genbank") que incluye la secuencia genómica al final, precedida
# por la palabra ORIGIN y seguida por una doble barra, así:
# 
# ORIGIN
# [muchísimas líneas de secuencia genómica]
# //
# 
# Actualmente suele publicarse el gbk con los datos de anotación por un lado, y la secuencia 
# por otro, por lo que hay que insertarla en su lugar, dentro del archivo gbk, para usarla 
# como input del programa que usaremos acá. Lo más fácil es borrar la última línea (la que 
# tiene la doble barra) usando sed '1000d' archivo.gbk >nuevo.gbk (suponiendo que tiene mil 
# líneas), y después pegando con cat la secuencia genómica, y agregando con otro 
# cat >> nuevo.gbk las dos barras que eliminamos recién.
# 
# 
# GC skew absoluto: hay un índice, llamado gcskew relativo, que = (G-C)/(G+C), o sea, 
# la diferencia entre las G y C de una hebra, dividida el total de G y C en dicha hebra.
# Por ejemplo, en 
# ATGGCA
# tenemos 2G y 1C, por lo que el GCskew es
# (2-1)/(2+1) = 0.333.
# Si fuera la hebra complemantaria TGCCAT, 2C y 1G, sería
# (1-2)/(1+2) = -0.333
# Si fueran iguales, daría 0, por ser (n-n)/n+n = 0 para cualquier n distinto de cero.
# Por lo general, los CDSs tienen, en su secuencia "publicada" (ya veremos qué 
# significa eso) más G que C, por lo que su GCskew es positivo.
# 
# Otro índice, que llamaremos C-G ("C menos G") skew, es el que usa 
# el programa de R "oriloc", y es simplemente C-G, y se comporta al revés: el C-G skew 
# tiende a ser negativo (y por lo tanto decrecer si es acumuado) en la "secuencia publicada".
# La principal diferencia, aparte de que la resta se hace al revés (por lo que los 
# gráficos también se interpretan al revés) es que un C-G de 100, así solo, en teoría, 
# puede no ser muy informativo si no decimos cuánto es el total de G y C. Por ejemplo, 
# puede ser 2000-1900, o 101-1. Ambos dan 100, pero el GCskew relativo sería 100/3900 = 0.026 
# en el primer caso, y 100/102 = 0.98 en el segundo. Claro que en la naturaleza las diferencias 
# no son tan extremas, por lo que ese defecto se disimula bastante.
# 
# ################################################################################################################################
# De acuerdo a cómo se replica el ADN, las hebras se llaman leading (o leader), y lagging.
# Cada hebra sirve de molde a una nueva, y el sentido de la replicación es 5'-3' en la hebra 
# que se va sintetizando. Pero la replicación va hacia un lado (considerando ambas hebras) 
# por lo que la hebra nueva que está en sentido 5'-3' se va sintetizando continuamente, 
# y la otra por fragmentos.
# La hebra leader es la que se replica en forma continua, y la hebra nueva se va sintetizando 
# es su complementaria, la futura hebra "retrasada".
# 
#    Hebra nueva: 5' ...CTGTCA..... 3'
#    Hebra molde: 3' ...GACAGTTT... 5'
#    Sentido de la síntesis: →
#
# (o sea, la última base que se agregó en la hebra nueva es la A). 
# Si la horquilla de replicación se va abriendo también en este sentido → , o sea, en el sentido
# 5'-3' de la hebra nueva, la hebra molde de la replicación se llama leader. Es importante
# tener claro que, cualquiera sea el sentido en que avanza la horquilla, siempre la síntesis
# se produce hacia ese lado en una hebra y hacia el otro (dentro de cada fragmento) en la otra; 
# es esta la que debe sintetizarse de a fragmentos. Cada fragmento se sintetiza en sentido 5'-3', 
# pero los sucesivos fragmentos van siendo agregados, uno tras otro, en sentido 3'-5'.
# 
# En la transcripción de ARNm solo se usa un molde, y si el ARNm será 
# Hebra nueva (ARN) 5' ...AUGUCC... 3'
# Hebra molde (ADN) 3' ...TACAGG... 5'
# La transcripción se da, en la mayoría de los genes (por la hebra en que se ubican), en el 
# mismo sentido (me refiero al sentido en que avanza la horquilla) que la replicación.
# 
# IMPORTANTE: en el caso de los CDSs tenemos la hebra codificante (sense strand) y la 
# no codificante (antisense). La codificante tiene la misma secuencia del ARNm 
# (salvo por las T en vez de U), por lo que la antisense es la que sirve de molde al ARNm. 
# La mayoría (alrededor de 2/3) de los CDS tiene su hebra codificante en la hebra leader 
# (por causas que aún se discuten). La que se publica como CDS, digamos, que empieza con ATG 
# y termina con TAA o algún otro codón stop, es la codificante: en otras palabras, la 
# complementaria de la que sirve de molde al ARNm. Cuando decimos que un gen "está" en 
# determinada hebra, estamos diciendo que su secuencia ATG...STOP (codificante) está en ella
# en sentido 5' 3', por lo que lo que el mensajero empieza a sintetizarse del lado del AUG.
# Pero en el ADN genómico algunos CDSs están en un sentido y otros en otro, porque se 
# secuencia y ensambla una hebra de todo el cromosoma. Si están en sentido "directo" 
# (se publicó su secuencia 5'-3') la secuencia que vemos dentro de la secuencia 
# genómica será sense, la misma que cuando se publica -aparte- la secuencia del CDS. 
# Si no, en la anotación nos avisan (comunmente, al lado de las coordenadas, aparece la 
# palabra REVERSE, COMPLEMENT, ANTISENSE o el signo de menos).
# 
# En la hebra sense (así como en la secuencia publicada en el caso de los CDSs) el C-G skew 
# tiende a ser negativo, ya que la tendencia es que haya más G que C, mientras que en la hebra 
# lagging o retrasada es positivo. Como la mayoría tienen su hebra sense en la leader, la hebra 
# leader tenderá a tener C-G skew negativo. Como la replicación se inicia hacia ambos lados del 
# origen (imaginemos el círculo, y el origen ubicado "a las 12", la hebra que es leader en sentido 
# horario, es retrasada en sentido antihorario (ya que las horquillas se desplazan en sentidos 
# opuestos). Por lo que en el origen cambiará el sentido del C-G skew. También lo hará en la "antípoda" 
# del origen; donde se terminan ambos procesos replicativos (el que va en una dirección, y el otro).
# Tenemos entonces:
# 1) la hebra leading suele ser "sense" de la mayoría de los genes durante la transcripción.
# 2) la hebra codificante tiene la misma secuencia que el ARNm, y que el CDS publicado.
# 3) 2/3 de los CDSs tiene su hebra codificante en la hebra que actúa como leader durante la replicación.
# 4) Por lo tanto, si la mayoría de los CDSs tienen más G que C, la hebra sense también los tendrá. 
# 5) Entonces, una forma de detectar cuál es la hebra leader, es buscar la que tiene más G que C, 
#    porque al estar la mayoría de las codificantes de CDS en ella, globalmente tendrá a haber un sesgo 
#    de G > C en dicha hebra.
# 6) Si el gráfico de C-G da una línea (más o menos) horizontal de valores negativos en el eje "Y" 
#    en la hebra leader y positivos en la lagging, cuando hacemos el plot acumulativo (el valor del eje
#    Y de cada punto es se suma al de todos los anteriores) la línea tendrá pediente negativa en la 
#    hebra leading y positiva en la lagging. (Con el GCskew pasa al revés, por lo que al mirar un gráfico
#    hay que saber qué fue lo que se usó).
# 7) Por como se da la replicación en el cromosoma circular de las bacterias, la horquilla empieza en un 
# punto (origen) y avanza hacia ambos lados. Si secuenciamos una hebra entera del genoma, la mitad 
# corresponderá a la hebra leader y la mitad a la lagging. Recomiendo buscar imágenes y videos en 
# internet que ilustren esto para terminar de entenderlo.
# 8) cuando las dos horquillas se juntan en las "antípodas" del origen, tenemos el punto "fin de la replicación".
# 9) Si tenemos una gran zona (del gráfico C-G skew acumulado) con pendiente negativa \, esa zona empieza
# en el origen y termina en el fin de la replicación. Las zonas con pendiente positiva / empiezan en el fin 
# y terminan en el origen (de izquierda a derecha). Para ir del origen al fin hay que "bajar", y para ir 
# del fin al origen, hay que "subir".
# ################################################################################################################################
# 
# 
# El comando oriloc funciona con valores por defecto correspondientes a un genoma que está "incluido" en R; veamos
# ?oriloc
# RECORDAR que aquí NO se usa el GC skew relativo (el que definimos primero) sino uno absoluto, 
# (sólo la diferencia) pero además, y esto es lo más importante, no usa la diferencia G-C sino C-G, 
# con lo cual la hebra leader tendrá sesgo negativo (y por lo tanto el acumulado tendrá pendiente negativa) 
# y al revés en la retrasada.
# En realidad usa solo las secuencias de CDS, y de ellas, las terceras posiciones, que son las que 
# más pueden variar y por lo tanto generar el C-G skew. 
# 
# Esta explicación parece entreverar las cosas, pero es bueno tener estas diferencias presentes 
# para prestar atención a qué sesgo se refiere un trabajo, y poder interpretar correctamente los gráficos, 
# o simplemente entender por qué en algunos sitios web nos van a enseñar a interpretar los gráficos de 
# un modo aparentemente contradictorio.
#  
# Por lo tanto, en el caso de C-G skew, el "pico" positivo (Λ) significa origen de la replicación, 
# y el negativo (V) su finalización.
# 
# 
# 
# En el sitio http://pbil.univ-lyon1.fr/software/Oriloc/howto.html hay una explicación (en inglés) 
# de cómo interpretar los plots como el que haremos. 
# 
# 
# Más resumido aún: en su hebra codificante, los CDS suelen tener más G que C (o sea, C-G negativo,
# línea descendente en el gráfico acumulado). A su vez, los genes suelen disponerse de modo que su 
# hebra codificante coincida con la hebra leading de la replicación.
# La suma de estos dos factores hace que en la hebra leading tienda a haber más G que C.
# 
# 
# Una vez comprendido esto, hagamos
library(seqinr)

gbk = "EcoliPl1.gbff"
bacdf = oriloc(gbk = gbk)
#bacdf <- oriloc(gbk="CP007025.gbk") # el nombre bacdf es por "bacteria data.frame". 
# GCA_000005845.2_ASM584v2_genomic.gbff
draw.oriloc(bacdf)

#Hagamos 
?draw.oriloc
bacdf
# todo eso se puede modificar:
draw.oriloc(ori, main = "Title",
  xlab = "Map position in Kb",
  ylab = "Cumulated combined skew in Kb", las = 1, las.right = 3,
  ta.mtext = "Cumul. T-A skew", ta.col = "pink", ta.lwd = 1,
  cg.mtext = "Cumul. C-G skew", cg.col = "lightblue", cg.lwd = 1,
  cds.mtext = "Cumul. CDS skew", cds.col = "lightgreen", cds.lwd = 1,
  sk.col = "black", sk.lwd = 2,
  add.grid = TRUE, ...)
  
# Vemos varias líneas, que representan distintos índices. El C-G es la línea azul 
# claro (lightblue, según su valor por defecto).
# la forma de Λ indica que el origen está más o menos en el centro del gráfico (~220 kb) y el
# fin podemos decir que está al principio o al final (como el cromosoma es circular, es lo mismo). 

# Vamos a destacar el C-G skew, dándole un color más notorio y engrosando la línea.
# También afinaremos la línea negra (sk), que es el resultado de una regresión hecha 
# a partir de T-A y C-G skew, que no nos interesa de momento.



draw.oriloc(bacdf,cg.col="blue",cg.lwd=2,sk.col="gray",sk.lwd=1) # Este es el comando que usaremos

# En algunos casos puede estar más claro el T-A skew (o incluso el skew combinado, que intenta usar ambos
# sesgos a la vez) y ayudar a ubicar el origen y la terminación de la replicación.

f=read.fasta("GCA_000008865.2_ASM886v2_cds_from_genomic.fna")
cmenosg=function(seqdna){
  cuenta= count(seqdna,wordsize = 1,start = 0,by = 1,alphabet = s2c("acgt"))
  return(cuenta[2]-cuenta[3])
}
cmg=sapply(f,cmenosg)
plot(cmg,type="l")
abline(h=0,col="red")
boxplot(cmg,outline = FALSE)
length(cmg)
length(which(cmg==0))/length(cmg)
mean(cmg[which(cmg>0)])
