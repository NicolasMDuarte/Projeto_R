library(ggplot2) #usando biblioteca do ggplot2
library(cowplot)

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
data <- data[data$sensa <= 40,] #remocao de dados absurdos
data <- na.omit(data) #remocao de dados incompletos ou ausentes

#desenho dos graficos
horSensa <- ggplot(data, aes(x = horario, y = sensa, color=sensa)) + #definicao dos dados e daquele que definira a cor do grafico
  geom_point(alpha = 0.1) + #grafico de pontos
  labs(x = "Ano", y = "Sens. Térm.(°C)", color = "Sens. Térm.(°C)") + #legendas
  coord_cartesian(ylim=c(-10,40)) + #limites para o grafico
  scale_color_gradient(low="turquoise3", high="violetred2") #gradiente de cor
horTemp <- ggplot(data, aes(x = horario, y = temp, color=temp)) +
  geom_point(alpha = 0.1) +
  labs(x = "Ano", y = "Temperatura (°C)", color = "Temperatura (°C)") +
  coord_cartesian(ylim=c(0,40)) +
  scale_color_gradient(low="coral", high="red")
horVent <- ggplot(data, aes(x = horario, y = vento, color=vento)) +
  geom_point(alpha = 0.1) +
  labs(x = "Ano", y = "Vento (Km/h)", color = "Vento") +
  coord_cartesian(ylim=c(0,125)) +
  scale_color_gradient(low="seagreen1", high="seagreen")
horUmid <- ggplot(data, aes(x = horario, y = umid, color=umid)) +
  geom_point(alpha = 0.1) +
  labs(x = "Ano", y = "Umidade (%)", color = "Umidade") +
  coord_cartesian(ylim=c(-20,100)) +
  scale_color_gradient(low="deepskyblue", high="deepskyblue4")
tempSensa <- ggplot(data, aes(x = temp, y = sensa, color=sensa)) +
  geom_point(alpha = 0.1) +
  labs(x = "Temp. (°C)", y = "Sens. Térm.(°C)", color = "Sens. Térm.(°C)") +
  coord_cartesian(ylim=c(-10,40)) +
  scale_color_gradient(low="turquoise3", high="violetred2") 
sensaVent <- ggplot(data, aes(x = sensa, y = vento, color=vento)) +
  geom_point(alpha = 0.1) +
  labs(x = "Sens. Térm.(°C)", y = "Vento (Km/h)", color = "Vento") +
  coord_cartesian(ylim=c(0,125)) +
  scale_color_gradient(low="seagreen1", high="seagreen") 

save_plot("plot.png", plot_grid(horSensa, horTemp, horVent, horUmid, tempSensa, sensaVent, labels = "AUTO"), ncol = 2, base_height = 5) #salva os dados

rm(list=ls()) #remove as variaveis
