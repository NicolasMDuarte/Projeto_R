library(ggplot2) #usando biblioteca do ggplot2
library(cowplot)
library(dplyr)
library(magrittr)
library(ggplot2)
library(ggridges)
library(lubridate)

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

horSensa <- ggplot(data, aes(x = horario, y = sensa, color=sensa)) +
  geom_point(alpha = 0.1) +
  labs(x = "Ano", y = "Sens. Térm.(°C)", color = "Sens. Térm.(°C)") +
  coord_cartesian(ylim=c(-10,40)) +
  scale_color_gradient(low="turquoise3", high="violetred2") #desenho dos graficos

horTemp <- ggplot(data, aes(x = horario, y = temp, color=temp)) +
  geom_point(alpha = 0.1) +
  labs(x = "Ano", y = "Temperatura (°C)", color = "Temperatura (°C)") +
  coord_cartesian(ylim=c(0,40)) +
  scale_color_gradient(low="coral", high="red") #desenho dos graficos

horVent <- ggplot(data, aes(x = horario, y = vento, color=vento)) +
  geom_point(alpha = 0.1) +
  labs(x = "Ano", y = "Vento (Km/h)", color = "Vento") +
  coord_cartesian(ylim=c(0,150)) +
  scale_color_gradient(low="seagreen1", high="seagreen") #desenho dos graficos

horUmid <- ggplot(data, aes(x = horario, y = umid, color=umid)) +
  geom_point(alpha = 0.1) +
  labs(x = "Ano", y = "Umidade (%)", color = "Umidade") +
  coord_cartesian(ylim=c(-20,100)) +
  scale_color_gradient(low="deepskyblue", high="deepskyblue4")#desenho dos graficos

tempSensa <- ggplot(data, aes(x = temp, y = sensa, color=sensa)) +
  geom_point(alpha = 0.1) +
  labs(x = "Temp. (°C)", y = "Sens. Térm.(°C)", color = "Sens. Térm.(°C)") +
  coord_cartesian(ylim=c(-10,40)) +
  scale_color_gradient(low="turquoise3", high="violetred2") #desenho dos graficos

sensaVent <- ggplot(data, aes(x = sensa, y = vento, color=vento)) +
  geom_point(alpha = 0.1) +
  labs(x = "Sens. Térm.(°C)", y = "Vento (Km/h)", color = "Vento") +
  coord_cartesian(ylim=c(0,125)) +
  scale_color_gradient(low="seagreen1", high="seagreen") #desenho dos graficos

mMes <- data %>%
  mutate(dia = floor_date(as.Date(horario, unit="months", format="%d/%m/%Y"))) %>%
  group_by(dia) %>%
  summarize(Temperatura = mean(as.numeric(temp)), Sensacao = mean(sensa), mes=month(dia))
tempAno <- ggplot(mMes, aes(x= Temperatura, y = as.factor(mes), fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 2, rel_min_height = 0.01) +
  labs(x = "Temperatura (°C)", y = "Média dos meses") + 
  scale_fill_viridis_c(name = "Temp. [C]", option = "C") + 
  theme_ridges(grid = TRUE)

mAno_temp <- data %>%
  mutate(Ano = floor_date(unit = "year", x = as.Date(horario, format="%d/%m/%Y"))) %>%
  group_by(Ano) %>%
  summarize(Temperatura = mean(as.numeric(temp)))
tempBarAno <- ggplot(mAno_temp, aes(x = Ano, y = Temperatura)) + geom_col(colour="coral", fill="coral") + coord_cartesian(ylim= c(21,23))

mUmid_temp <- data %>%
  mutate(Ano = floor_date(unit = "year", x = as.Date(horario, format="%d/%m/%Y"))) %>%
  group_by(Ano) %>%
  summarize(Umidade = mean(as.numeric(umid)))
umidAno <- ggplot(mUmid_temp, aes(x = Ano, y = Umidade)) + geom_line(color="deepSkyBlue4") + coord_cartesian(ylim= c(0,100))


save_plot("plot.png", plot_grid(horSensa, horTemp, horVent, horUmid, tempSensa, sensaVent, tempAno, tempBarAno, umidAno, labels = "AUTO"), ncol = 2, base_height = 10)

#dev.off () # Fecha o arquivo
rm(list=ls()) #remove as variaveis