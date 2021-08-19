install.packages("cran/ggplot2")
library(ggplot2)

names <- c("horario", "temp", "vento", "umid", "sensa")
con <- url("http://ic.unicamp.br/~zanoni/cepagri/cepagri.csv")
cepagri <- read.csv(con, header = FALSE, sep = ";", col.names = names)
                    
horario <- as.data.frame(cepagri$horario)
temp <- as.data.frame(cepagri$temp)
vento <- as.data.frame(cepagri$vento)
umid <- as.data.frame(cepagri$umid)
sensa <- as.data.frame(cepagri$sensa)

pdf("grafico.pdf") # Indica o arquivo que o gráfico será salvo
p <- ggplot(horario, aes(x = horario,y = temp)) # Gera o gráfico
p <- p + geom_point() # Adiciona camada: Gráfico de Pontos
p <- p + geom_line() # Adiciona camada: Gráfico de Linha
print(p) # Salva o gráfico no arquivo indicado
dev.off () # Fecha o arquivo

remove.packages('ggplot2')
rm(list=ls())
