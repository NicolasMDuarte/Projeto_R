install.packages("ggplot2")
library(ggplot2)

names <- c("horario", "temp", "vento", "umid", "sensa")
con <- url("http://ic.unicamp.br/~zanoni/cepagri/cepagri.csv")
cepagri <- read.csv(con, header = FALSE, sep = ";", col.names = names)

horario <- as.Date(strtrim(cepagri$horario, 10), format = "%d/%m/%Y")
temp <- cepagri$temp
vento <- cepagri$vento
umid <- cepagri$umid
sensa <- cepagri$sensa

start_date <- as.Date("2015/01/01")
end_date <- as.Date("2020/12/31")
hor <- horario[horario >= start_date & horario <= end_date]

df <- data.frame(horario, temp)

pdf("grafico.pdf") # Indica o arquivo que o gr�fico ser� salvo
p <- ggplot(df, aes(x = horario,y = temp)) # Gera o gr�fico
p <- p + geom_point() # Adiciona camada: Gr�fico de Pontos
p <- p + geom_line() # Adiciona camada: Gr�fico de Linha
print(p) # Salva o gr�fico no arquivo indicado
dev.off () # Fecha o arquivo

remove.packages('ggplot2')
rm(list=ls())
