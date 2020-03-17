library(fpp2)
library(ggplot2)

# Read in seasonality removed CPI time-series csv
# Consumer Price Index for All Urban Consumers: All Items in U.S. City Average

cpits <- read.csv(file = 'C:/Users/Sambus/CPI_TimeSeries/CPIAUCSL.CSV')

# Creating time series object

cpits <- ts(cpits, start=c(1947), end=c(2017), frequency=12)
cpits

# Examining the plot
tiff("tsgraph.jpg", units="px", width=600, height=600, res=150)
autoplot(cpits) +
  ggtitle("CPI index from 1947 to 2016") +
  xlab("Year") +
  ylab("Index value")
dev.off()

# Seasonal plot, linear and polar

ggseasonplot(cpits, year.labels = TRUE, year.labels.left = TRUE) +
  ylab("Index") +
  ggtitle("Seasonal plot: CPI Index 1947 to 2016")

ggseasonplot(cpits, polar = TRUE) +
  ylab("Index") +
  ggtitle("Polar Seasonal plot: CPI Index 1947 to 2016")

# Subseries plot

ggsubseriesplot(cpits) +
  ylab("index") +
  ggtitle("Seasonal subseries plot: CPI index")

# Lag plot
tiff("lagplot.jpg", units="px", width=800, height=800, res=150)
gglagplot(cpits)
dev.off()

# Autocorrelation function
# shows the time series is trended
ggAcf(cpits)

# METHOD TESTING - Just for fun and learning
# Mean forecast method
meanf(cpits, h = 37)

# Naive
naive(cpits, h=37)

# Seasonal naive, don't use--data is not seasonal
snaive(cpits, h=37)

# Drift method
rwf(cpits, h = 37, drift = TRUE)



# PLOT TESTING
tiff("tstest.png", units="px", width=1200, height=800, res=150)
autoplot(cpits) +
  autolayer(meanf(cpits, h = 37),
            series = "Mean", PI=FALSE) +
  autolayer(snaive(cpits, h = 37),
            series = "snaive", PI=FALSE) +
  autolayer(rwf(cpits, h = 37, drift = TRUE),
            series = "Drift", PI=FALSE) +
  ggtitle("Trend forecasts for CPI Index of All Urban Consumers") +
  xlab("Year") +
  ylab("Index") +
  guides(colour = guide_legend(title = "Forecast"))
dev.off()
# Residual analysis of drift method
res <- residuals(rwf(cpits, h = 37, drift = TRUE))
autoplot(res) + xlab("Year") + ylab("") +
  ggtitle("Residual plot of drift method for CPI")

gghistogram(res) + ggtitle("Histogram of Residuals")

ggAcf(res)

checkresiduals(res)

Box.test(res, lag=10, fitdf = 0)

# training
train <- window(cpits, start = 1947, end = 2010)

fit1 <- meanf(train, h = 84)
fit2 <- snaive(train, h = 84)
fit3 <- rwf(train, h = 84, drift = TRUE)


tiff("tstrain.png", units="px", width=1200, height=800, res=150)
autoplot(cpits) +
  autolayer(fit1, series = "Mean", PI=FALSE) +
  autolayer(fit2, series = "Seasonal Naive", PI=FALSE) +
  autolayer(fit3, series = "Drift", PI=FALSE) +
  ggtitle("Forecasts for CPI Index of all urban consumer") +
  xlab("Year") +
  ylab("Index") +
  guides(colour = guide_legend(title = "Forecast"))
dev.off()

win3 <- window(cpits, start=2010)
accuracy(fit1, win3)
accuracy(fit2, win3)
accuracy(fit3, win3)

# Drift is the best

