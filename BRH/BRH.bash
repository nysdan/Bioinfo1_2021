# en gedit poner este archivo en modo resaltado para sh o bash (menú Ver-> Modo resaltado -> scripts -> sh)

# $1 es el fasta con los genes del organismo 1
# $2 es el fasta con los genes del organismo 2

# hago el blast 1 vs 2

 makeblastdb -in $2 -dbtype prot -out $2.base
 blastp -query $1 -db $2.base -outfmt "6 std qlen slen" -out tablast.$1.$2 -max_target_seqs 1 -num_threads 2 -evalue 1e-5

# el resultado está en tablast.$1.vs.$2. Ahora hago el blast inverso.

 makeblastdb -in $1 -dbtype prot -out $1.base
 blastp -query $2 -db $1.base -outfmt "6 std qlen slen" -out tablast.$2.$1 -max_target_seqs 1 -num_threads 2 -evalue 1e-5

# el resultado está en tablast.$2.vs.$1. Ahora me quedo con las dos primeras columnas de tablast.

cat tablast.$1.$2 |cut -f1,2 > $1.BH
cat tablast.$2.$1 |cut -f1,2 > $2.BH

# uno tiene los genes 1 a la izquierda y los genes 2 a la derecha, y el otro a la inversa. Invierto el segundo.
# lo que hay entre las comillas (al lado del print) es un tab, para que se mantenga la estructura gen-tab-gen

cat $2.BH |awk '{print $2"	"$1}' > $2.HB   # ojo que es un tab lo que hay entre las comillas dobles.

# lo llamo $2.HB para representar que es el mismo que $2.BH pero con las columnas intercambiadas.
# ahora los junto en un archivo, y hago un sort|uniq -c, que me da cuántas veces aparece cada par.
# si un par "a b" aparece dos veces, significa que el best hit de a era b, y el best hit de b era a.

cat $1.BH $2.HB | sort | uniq -c | grep -v "      1 "| awk '{print $2"	"$3}' > BRH.$1-$2 
# Acá también, verificar que lo que está entre el $2 y el $3, entre comillas, es un TAB.

# para entender este largo pipe-line hay que ir haciéndolo por partes (justo hasta antes de cada |) e ir viendo qué pasa.
# muevo los archivos que tal vez use a una carpeta que se llamará "archivos", para no tener tanta cosa junta. Si la carpeta
# ya está hecha (de una corrida anterior) te sale un warning, pero no importa.

mkdir archivos
mv *.BH  *.HB archivos