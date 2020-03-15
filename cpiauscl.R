library(ggplot2)
library(dplyr)
library(forecast)
library(tseries)

# Read in seasonality removed CPI time-series csv
# Consumer Price Index for All Urban Consumers: All Items in U.S. City Average

cpits <- read.csv(file = 'C:/Users/Sambus/Desktop/CPI/CPIAUCSL.CSV')

# define the time-series and examine

cpits <- ts(cpits, start=c(1947), end=c(2017), frequency=12)
head(cpits)
plot(cpits)

# Is the TS stationary?

adf.test(cpits)
kpss.test(cpits)
# NON-STATIONARY

# Decomposing the time-series

cpifit <- decompose(cpits)
plot(cpifit)


# Precidtive modeling using Holt-Winters Exponential Smoothing minus seasonality gamma

cpiforecast <- HoltWinters(cpits, gamma = FALSE)
#cpiforecast <- ets(cpits)
cpiforecast
cpiforecast$SSE

plot(cpiforecast)

# residuals

res <- residuals(cpiforecast)
autoplot(res)
# Skewed histo
gghistogram(res) + ggtitle("Histogram of residuals")
ggAcf(res) + ggtitle("ACF of Residuals")

forecast(cpiforecast, 37)
plot(forecast(cpiforecast, 37))

# ARIMA fit

cpiforecast2 <- auto.arima(cpits)
cpiforecast2
cpiforecast2$SSE

# residuals

res2 <- residuals(cpiforecast2)
autoplot(res2)
gghistogram(res2) + ggtitle("Histogram of residuals")
ggAcf(res2) + ggtitle("ACF of Residuals")

forecast(cpiforecast2, 37)
plot(forecast(cpiforecast2, 37))

