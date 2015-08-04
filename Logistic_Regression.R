###To contact the author ahmed.rebai2@gmail.com


#################################################################
### Fitting Logistic Regression in R								##
### Data Set : Smarket (S&P stock index, 1250 obs, 9 variables)##
#################################################################

### Step 1 : Load data, and run numerical and graphical summeries

library(ISLR)
ls(package:ISLR)
attach(Smarket)
summary(Smarket)
class(Smarket)
names(Smarket)
cor(Smarket[,-9])   # correlation study
pairs(Smarket[,-9]) # plot each variable against other



### Step 2 : Split the data into training and testing data 
training = (Year < 2005)
testing = !training # complementary to training (i.e = 2005)

training_data = Smarket[training,]
testing_data = Smarket[testing,] ##we can use also !training

Direction_testing = Direction[testing]

### Step 3 : Fit a logistic regression model using training data
stock_model = glm(Direction ~ Lag1+Lag2+Lag3+Lag4+Lag5+Volume,
data = training_data, family = binomial)
plot(stock_model)
print(stock_model)
summary(stock_model)

### Step 4 : Use the fitted model to do predictions for the test data

model_pred_probs = predict(stock_model, testing_data, type = "response")
model_pred_Direction = rep("Down", 252)
model_pred_Direction[model_pred_probs > 0.5] = "Up"

### Step 5 : Create the confusion matrix, and compute the misclassification rate

table(model_pred_Direction,Direction_testing)
mean(model_pred_Direction != Direction_testing) # 51.9%




