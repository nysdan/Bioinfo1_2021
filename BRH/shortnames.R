filename="Ecoli" # el archivo original, en este caso, se llama Ecoli.cds

library(seqinr)
fasnuc = read.fasta(paste(filename,"cds",sep = ".")) # el nombre real del archivo

len = length(fasnuc)
head(names(fasnuc))
namesOrig = names(fasnuc)

namesNew=c()
for(i in 1:len){
  namesNew[i]= paste("s",i,sep=".")
}

head(namesNew)



write.fasta(fasnuc,names=namesNew,file.out = paste("nc",filename,"cds",sep=".")) 
# nc =nombres cortos
faspep = lapply(fas,translate)
write.fasta(faspep,names = names,file.out = paste("nc",filename,"pep",sep="."))

dfnames=data.frame(namesNew,namesOrig)
head(dfnames)
write.table(dfnames,quote=FALSE,row.names = FALSE,
            file=paste("nm",filename,sep = "."),sep="\t")


###### fin del script (lo que sigue es para hacer cosas en clase) #######



system("./runBlastp.bash Ecoli.pep Ecoli.pep")

t=read.table("tablast.bicho1nc.pep-bicho1nc.pep")
colnames(t)= c("query","subject","p_id_aln","len_aln","mism","gapop",
      "qstart","qend","sstart","send","evalue","score","qlen","slen")
head(t)

# Podemos filtrar la tabla desde aquí

borrar=which(t$query == t$subject)
t2=t[-borrar,]
dim(t)
dim(t2)

borrar=which(t2$p_id_aln<50)
t3 = t2[-borrar,]
dim(t3)