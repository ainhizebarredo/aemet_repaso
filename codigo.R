library(climaemet)
library(dplyr)
library(lubridate)
library(ggplot2)
apikey = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJibXVuaXpAbW9uZHJhZ29uLmVkdSIsImp0aSI6IjM5N2Y0Zjg2LTE0N2MtNGFjYy05ZjI4LTExYjZiODk3NzE4MCIsImlzcyI6IkFFTUVUIiwiaWF0IjoxNjQ3MjY0NzA4LCJ1c2VySWQiOiIzOTdmNGY4Ni0xNDdjLTRhY2MtOWYyOC0xMWI2Yjg5NzcxODAiLCJyb2xlIjoiIn0.h4cBR_lOro719PbcSJ_4J3DtggMDV2dCcyolWDWv6TQ"
aemet_api_key(apikey, overwrite = TRUE, install = TRUE)
datos<-aemet_daily_clim(
  station = "all",
  start = '2022-01-01',
  end = '2022-05-31',
  verbose = FALSE,
  return_sf = FALSE
)

datos$tmed<-as.numeric(gsub(',','.',datos$tmed))
datos$prec<-as.numeric(gsub(',','.',datos$prec))
df_cadiz<-datos%>%
  filter(provincia=='CADIZ' & altitud<500)
df_cadiz$fecha<-month(df_cadiz$fecha)

df_cadiz<-df_cadiz%>%
  group_by(fecha)%>%
  summarise(t_med=mean(tmed, na.rm=T),p_med=mean(prec, na.rm=T))

ggplot(df_cadiz, aes(x=fecha, y=t_med))+geom_line()+theme_bw()
ggplot(df_cadiz, aes(x=fecha, y=p_med))+geom_line()+theme_bw()

