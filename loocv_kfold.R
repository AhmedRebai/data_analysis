###To contact the author ahmed.rebai2@gmail.com

library(ISLR)
library(boot)

### LOOCV approach

attach(Auto)
model = glm(mpg ~ horsepower, data = Auto)

MSE_LOOCV = cv.glm(Auto, model)

## Another method MSE_LOOCV = cv.glm(Auto, model)$delta[1]

MSE_LOOCV$delta[1]
MSE_LOOCV$delta[2]



## Loop
MSE_LOOCV = NULL
for (i in 1:10){

model = glm(mpg ~ poly(horsepower, i), data = Auto)
MSE_LOOCV[i] = cv.glm(Auto, model)$delta[1]

}

set.seed(1)

#### K-fold CV 

MSE_10_fold_cv = NULL
for (i in 1:10){

model = glm(mpg ~ poly(horsepower, i), data = Auto)
MSE_10_fold_cv[i] = cv.glm(Auto, model, K = 10)$delta[1]

}
MSE_10_fold_cv







