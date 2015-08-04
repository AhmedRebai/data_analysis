###To contact the author ahmed.rebai2@gmail.com

### Classification Methods Error Rates: Smarket Data Set ####

### LR  : Logistic Regression 44.05%
### LDA : Linear Discriminant Analysis 44.05% 
### QDA : Quadratic Discriminant Analysis 40.08%
### KNN : K Nearest Neighbours 46.83% (with 3 neighbours)


### Loading data and 
library(ISLR)
ls(package:ISLR)
attach(Smarket)
summary(Smarket)
class(Smarket)
names(Smarket)
cor(Smarket[,-9])   # correlation study
pairs(Smarket[,-9]) # plot each variable against other


### Splitting data into training and testing parts

training = (Year < 2005)
testing = !training # complementary to training (i.e = 2005)
training_data = Smarket[training,]
testing_data = Smarket[testing,] ##we can use also !training
Direction_testing = Direction[testing]

### LR Logistic Regression method
stock_model = glm(Direction ~ Lag1+Lag2, data = training_data, family = binomial)
plot(stock_model)
print(stock_model)
summary(stock_model)
model_pred_probs = predict(stock_model, testing_data, type = "response")
model_pred_Direction = rep("Down", 252)
model_pred_Direction[model_pred_probs > 0.5] = "Up"
table(model_pred_Direction,Direction_testing)
mean(model_pred_Direction != Direction_testing)


### LDA 
## Fit the lda model based on the training data set
lda_model = lda(Direction ~ Lag1 + Lag2, data = training_data)
## Validate the lda model using the testing data set
lda_pred = predict(lda_model, testing_data)
names(lda_pred)
lda_pred_Direction = lda_pred$class
head(lda_pred_Direction)
## Confusion matrix
table(lda_pred_Direction, Direction_testing)
## misclassification error
mean(lda_pred_Direction != Direction_testing)


### QDA

qda_model = qda(Direction ~ Lag1+Lag2, data = training_data)
qda_pred = predict(qda_model, testing_data)
qda_pred_Direction = qda_pred$class
table(qda_pred_Direction, Direction_testing)
mean(qda_pred_Direction != Direction_testing)


### KNN

library(class)
std_data = scale(Smarket[,c(2,3)])
training_data = std_data[training,]
testing_data = std_data[testing,]
training_Direction = Direction[training]
knn_pred_Direction = knn(training_data, testing_data, training_Direction, 3 )
table(knn_pred_Direction, Direction_testing)
mean(knn_pred_Direction != Direction_testing) 



