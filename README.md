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

![graphic](https://i.imgur.com/LOcKnza.png)

It is clear to see that the data has an extremely positive trend with no visible seasonality of cycles. This can be confirmed by examining a lag plot or autocorrelation function plot--as a linear lag plot indicates that the data is non-random and has a strong trend.

![graphic](https://i.imgur.com/go0NYv5.png)

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
Resulting in the graph as follows. 
  
![graph](https://i.imgur.com/srkjjY2.png)

It seems that Drift would work well with our data here intuitively. So let's now train the models, and see how the actual results look along side of the forecast in addition to their comparitive errors.

### Training

First setting up the training window to allow the graphical overlap and to compare error to actual data.

```R
train <- window(cpits, start = 1947, end = 2010)
```

Then creating forecasts of years data after the training time series data ends.

```R
fit1 <- meanf(train, h = 84)
fit2 <- snaive(train, h = 84)
fit3 <- rwf(train, h = 84, drift = TRUE)
```
![image](https://i.imgur.com/Md3w3xA.png)

As expected, the drift is a great choice for a more straight-forward train such as CPI index data. The seasonal naive approach is not great in that it's trying to replicate a seasonality that has been removed from data to begin with. And the mean approach is just not good as it's taking the mean of the entire training dataset, and works much better for data that is stationary.

### Accuracy

We can compare the accuracy of each of the models by using the `accuracy()` function withing the `forecast` library.

```R
win3 <- window(cpits, start=2010)
accuracy(fit1, win3)
accuracy(fit2, win3)
accuracy(fit3, win3)
```
```
                       ME     RMSE      MAE       MPE      MAPE     MASE      ACF1 Theil's U
Training set 4.405089e-15  63.5366  57.0810 -75.46890 109.34492 17.97635 0.9965657        NA
Test set     1.415784e+02 141.7607 141.5784  60.99989  60.99989 44.58688 0.9555017  247.1734
> accuracy(fit2, win3)
                    ME      RMSE       MAE      MPE     MAPE     MASE      ACF1 Theil's U
Training set  3.107016  4.033606  3.175338 3.533793 3.634879 1.000000 0.9804806        NA
Test set     16.542167 18.023010 16.542167 7.044250 7.044250 5.209576 0.9482761  31.05791
> accuracy(fit3, win3)
                       ME      RMSE       MAE        MPE      MAPE       MASE      ACF1 Theil's U
Training set 3.632686e-15 0.3753425 0.2478708 -0.1974486 0.4158104 0.07806124 0.5556857        NA
Test set     3.670622e+00 4.1767785 3.8016340  1.5681476 1.6283286 1.19723748 0.9468200  7.278306
```

And it appears that the Drift forecast is the best option in terms of the simples models with a Mean Percent error of **1.56%**



