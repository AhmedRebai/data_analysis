### To contact the author ahmed.rebai2@gmail.com

### Linear Regression in R

## Simple linear regression
library(MASS)
attach(Boston)
names(Boston)
lm.fit = lm(medv-lstat)
summary(lm.fit)

plot(lm.fit) ## Very important function with deep interpretations

plot(lstat, medv, main = "Scatterplot", xlab = "Lstat", 
ylab = "Median Value")
abline(lm.fit, col = "red", lwd = 6)

## Multiple Linear Regression

pairs(Boston)

pairs(Boston[,c(1,3,7)]) ## Reduce variable in the pairs function
lm.fit2 = lm(medv ~ lstat + age)
summary(lm.fit2)
print(lm.fit)
plot(lm.fit2)


lm.fit3 = lm(medv ~., data = Boston) ## in function of all the variables
print(lm.fit3)

# if we want to exclude a variable, it is really simple just add
# -name_variable

lm.fit4 = lm(medv ~.-age, data = Boston)
print(lm.fit4)

# to eliminate another variable
lm.fit4 = lm(medv ~.-age-zn, data = Boston)
summary(lm.fit4)

## Interaction Terms
lm.fit5 = lm(medv ~ lstat*age)
summary(lm.fit5)
lm.fit6 = lm(medv ~ lstat+lstat:age)
summary(lm.fit6)

## Non-Linear Transformations for Predictors
lm.fit7 = lm(medv~poly(lstat, 2))
summary(lm.fit7)

# Now we vary the degree of the polynom to 6
# and every time we see the statistical significance
# here we stop at 5

lm.fit8 = lm(medv~poly(lstat, 6))
summary(lm.fit8)



### A very good examples in R for polynomial regression
require(stats);
require(graphics)
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)",
     las = 1)

lines(lowess(cars$speed, cars$dist, f = 2/3, iter = 3), col = "red")
title(main = "cars data")
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)",
     las = 1, log = "xy")
title(main = "cars data (logarithmic scales)")
lines(lowess(cars$speed, cars$dist, f = 2/3, iter = 3), col = "red")
summary(fm1 <- lm(log(dist) ~ log(speed), data = cars))
opar <- par(mfrow = c(2, 2), oma = c(0, 0, 1.1, 0),
            mar = c(4.1, 4.1, 2.1, 1.1))
plot(fm1)
par(opar)

## An example of polynomial regression
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)",
    las = 1, xlim = c(0, 25))
d <- seq(0, 25, length.out = 200)
for(degree in 1:4) {
  fm <- lm(dist ~ poly(speed, degree), data = cars)
  assign(paste("cars", degree, sep = "."), fm)
  lines(d, predict(fm, data.frame(speed = d)), col = degree)
}
anova(cars.1, cars.2, cars.3, cars.4)



