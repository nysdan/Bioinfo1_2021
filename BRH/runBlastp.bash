#!/bin/bash
# $1 es el query y $2 la base de datos

makeblastdb -in $2 -dbtype prot -out $2.base
blastp -query $1 -db $2.base -outfmt "6 std qlen slen" -out tablast.$1-$2 -num_threads 2 -evalue 1e-20


#    outfmt (formato de salida)
#    0 = pairwise,
#    1 = query-anchored showing identities,
#    2 = query-anchored no identities,
#    3 = flat query-anchored, show identities,
#    4 = flat query-anchored, no identities,
#    5 = XML Blast output,
#    6 = tabular,
#    7 = tabular with comment lines,
#    8 = Text ASN.1,
#    9 = Binary ASN.1,
#   10 = Comma-separated values,
#   11 = BLAST archive format (ASN.1) 

#    Opción 6:
#    qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore

#    -max_target_seqs (número >= 1)

# name     query and subject
# blastn   query is DNA, subject is DNA
# blastp   query is protein, subject is protein
# blastx   query is nucleic acid that is translated by the program into protein sequences (all 6 reading frames); subject database is protein
# tblastn  query is protein; database is DNA translated into protein sequences in all 6 reading frames.
# tblastx  query is DNA translated into protein, subject is nucleotide translated into protein. Both are translated into all 6 frames.

# si queremos agregar columnas (por ejemplo, largo del query y del subject) ponemos -outfmt "6 std qlen slen".
# std es la lista que hay unas líneas más arriba, que empieza con qseqid sseqid etc.
# Pero podríamos haber definido simplemente -outfmt"6 qseqid sseqid length qlen slen", por ejemplo, si quisiéramos solo comparar largos de la porción alineada con los largos de las dos secuencias enteras.
