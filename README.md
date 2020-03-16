# Time Series Forecasting of the Consumer Price Index for All Urban Consumers: All Items in U.S. City Average

Primarily written in **R**, the goal of this project is to analyze CPI time series data from the St. Louis FRED and implement reliable forecasting methods. Packages used include: `ggplot2 forecast stats fpp2`. 

## Data Analysis

The first step is to visualize the data and look for any visual cues of seasonality, trend, and cycles.

In R this can be done easily using the autoplot function:
```R
autoplot(cpits) +
  ggtitle("CPI index from 1947 to 2016") +
  xlab("Year") +
  ylab("Index value")
```
Resulting in the following graph.

GRAPH OF TS HERE

It is clear to see that the data has an extremely positive trend with no visible seasonality of cycles. This can be confirmed by examining a lag plot or autocorrelation function plot. 

IMAGE OF LAG PLOT HERE

## Forecasting Methods

From the previous section, it is clear that out of the basic forecast models--a drifting model would be a good fit. So let's test our intuition using visualizations.
```R
autoplot(cpits) +
  autolayer(meanf(cpits, h = 37),
            series = "Mean", PI=FALSE) +
  autolayer(snaive(cpits, h = 37),
            series = "snaive", PI=FALSE) +
  autolayer(rwf(cpits, h = 37, drift = TRUE),
            series = "Drift", PI=FALSE) +
  ggtitle("Forecasts for CPI Index of All Urban Consumers") +
  xlab("Year") +
  ylab("Index") +
  guides(colour = guide_legend(title = "Forecast"))
  ```
INSERT FORECAST GRAPHICS


