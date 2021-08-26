install.packages("ggplot2") #instalando pacote
library(ggplot2) #usando biblioteca do ggplot2

names <- c("horario", "temp", "vento", "umid", "sensa") #nomes dos campos
con <- url("http://ic.unicamp.br/~zanoni/cepagri/cepagri.csv") #conexao com o link dos dados
cepagri <- read.csv(con, header = FALSE, sep = ";", col.names = names) #leitura dos dados e salvamento em uma variavel

horario <- as.Date(strtrim(cepagri$horario, 10), format = "%d/%m/%Y") #coleta do horario em forma de Date
temp <- cepagri$temp #temperatura
vento <- cepagri$vento #vento
umid <- cepagri$umid #umidade
sensa <- cepagri$sensa #sensacao termica

start_date <- as.Date("2015/01/01") #data de inicio da analise
end_date <- as.Date("2020/12/31") #data de fim da analise

#data frame onde serao guardados os dados
data <- data.frame(
  horario = horario,
  temp = as.double(temp),
  vento = vento,
  umid = umid,
  sensa = sensa
)

data <- data[data$horario >= start_date & data$horario <= end_date,] #remocao das datas nao utilizadas para analise
data <- data[data$sensa <= 40,]

data <- na.omit(data) #remocao de dados incompletos ou ausentes

horSensa <- ggplot(data, aes(x = horario, y = sensa, color=sensa)) #desenho dos graficos
horTemp <- ggplot(data, aes(x = horario, y = temp, color=temp)) #desenho dos graficos
horVent <- ggplot(data, aes(x = horario, y = vento, color=vento)) #desenho dos graficos
horUmid <- ggplot(data, aes(x = horario, y = umid, color=umid)) #desenho dos graficos
tempSensa <- ggplot(data, aes(x = temp, y = sensa, color=sensa)) #desenho dos graficos
sensaVent <- ggplot(data, aes(x = sensa, y = vento, color=vento)) #desenho dos graficos

#desenho das analises
horSensa +
  geom_point(alpha = 0.1) +
  labs(x = "Horário", y = "Sensação Térmica(°C)", color = "Sensação Térmica(°C)") +
  coord_cartesian(ylim=c(-10,40)) +
  scale_color_gradient(low="blue", high="red")
horTemp +
  geom_point(alpha = 0.1) +
  labs(x = "Horário", y = "Temperatura (°C)", color = "Temperatura (°C)") +
  coord_cartesian(ylim=c(0,40)) +
  scale_color_gradient(low="blue", high="red")
horVent +
  geom_point(alpha = 0.1) +
  labs(x = "Horário", y = "Vento", color = "Vento") +
  coord_cartesian(ylim=c(0,150)) +
  scale_color_gradient(low="blue", high="red")
horUmid +
  geom_point(alpha = 0.1) +
  labs(x = "Horário", y = "Umidade", color = "Umidade") +
  coord_cartesian(ylim=c(-20,100)) +
  scale_color_gradient(low="blue", high="red")
tempSensa +
  geom_point(alpha = 0.1) +
  labs(x = "Temperatura (°C)", y = "Sensação Térmica(°C)", color = "Sensação Térmica(°C)") +
  coord_cartesian(ylim=c(-10,40)) +
  scale_color_gradient(low="blue", high="red")
sensaVent +
  geom_point(alpha = 0.1) +
  labs(x = "Sensação Térmica(°C)", y = "Vento", color = "Vento") +
  coord_cartesian(ylim=c(0,150)) +
  scale_color_gradient(low="blue", high="red")

#Salvando os graficos - NAO ESTA SALVANDO OS DADOS - TENTAR FAZER EM PNG OU SEI LA
pdf("grafico_horSensa.pdf") 
print(horSensa)
pdf("grafico_horTemp.pdf") 
print(horTemp)
pdf("grafico_horVent.pdf") 
print(horVent)
pdf("grafico_horUmid.pdf") 
print(horUmid)
pdf("grafico_tempSensa.pdf")
print(tempSensa)
pdf("grafico_sensaVent.pdf") 
print(sensaVent)

dev.off () # Fecha o arquivo

remove.packages('ggplot2') #remove os pacotes
rm(list=ls()) #remove as variaveis