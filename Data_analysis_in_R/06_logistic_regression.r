# ===============================================
# Introduction to Stats in R
# Module 6: binary logistic regression
# Date: 2023-08-30
#
# ===============================================

# 1. Loading the dataset and looking at its summary

# loading required modules
library("tidyverse")
library("httpgd")

# uploading the dataset
df <- read.csv("data/quality.csv")
head(df)

# listing the column names
colnames(df)

# Look at structure
str(df)
# ==================================================
# 2. Splitting the data

# Install and load caTools package
#install.packages("caTools")
library(caTools)

# Randomly split data
set.seed(88)
split <- sample.split(df$PoorCare, SplitRatio = 0.75)
split

# representation how the SplitRation works
table(split)
99/(99+32)
32/(99+32)

# Create training and testing sets
qualityTrain <- subset(df, split == TRUE)
qualityTest <- subset(df, split == FALSE)

# ==================================================
# 3. Logistic regression model

# Training dataset
# Logistic Regression Model
QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family=binomial)
summary(QualityLog)

# logit function
logitFunc <- QualityLog$coefficients[1] + 
    QualityLog$coefficients['OfficeVisits'] * qualityTrain$OfficeVisits + 
    QualityLog$coefficients['Narcotics'] * qualityTrain$Narcotics

# probability
prob <- 1/(1 + exp(-1*logitFunc))

plot(logitFunc, prob, xlab="Logit function", ylab="P(y=1)")
points(logitFunc, prob, pch = 23, bg = "lightblue", cex = 1.2)
abline(h=0.5, col="red", lty=2)
lines(logitFunc[order(logitFunc)], prob[order(prob)], col="#369ee098")
grid()

# Make predictions on training set
predictTrain = predict(QualityLog, type="response")

# Confusion matrix for threshold of 0.5
table(qualityTrain$PoorCare, predictTrain > 0.5)

# Accuracy
(70 + 10)/(70+4+15+10)
# Error rate
(15 + 4)/(70+4+15+10)
# Sensitivity
10/25
# Specificity
70/74

# Confusion matrix for threshold of 0.7
table(qualityTrain$PoorCare, predictTrain > 0.7)

# Accuracy
(73 + 8)/(73+1+17+8)
# Error rate
(17 + 1)/(73+1+17+8)
# Sensitivity
8/25
# Specificity
73/74

# Confusion matrix for threshold of 0.2
table(qualityTrain$PoorCare, predictTrain > 0.2)

# Accuracy
(54 + 16)/(54+20+9+16)
# Error rate
(20 + 9)/(54+20+9+16)
# Sensitivity
16/25
# Specificity
54/74
# ==================================================
# 4. ROCR plot

# Install and load ROCR package
# install.packages("ROCR")
library(ROCR)

# Prediction function
ROCRpred = prediction(predictTrain, qualityTrain$PoorCare)

# Performance function
ROCRperf = performance(ROCRpred, "tpr", "fpr")

# Plot ROC curve
plot(ROCRperf)

# Add colors
plot(ROCRperf, colorize=TRUE)

# Add threshold labels 
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))

# Confusion matrix for threshold of 0.35 (based on ROCR)
table(qualityTrain$PoorCare, predictTrain > 0.35)
# Accuracy
(69+12)/(69+12+5+13)
# Sensitivity
12/25
# Specificity
69/74

# plot the accuracy
acc <- performance(ROCRpred, measure="acc")
plot(acc)

# ==================================================
# 5. Area Under Curve

# calculation of area under curve AUC
#install.packages("pROC")
library("pROC")
# for training data
trainDataPred <- roc(qualityTrain$PoorCare, predictTrain)
auc(trainDataPred)
# plot
plot(ROCRperf, colorize=TRUE)
abline(a=0, b=1)

# ==================================================
# 6. Using it all for the test dataset

# predictions on test dataset
predictTest <- predict(QualityLog, type="response", newdata=qualityTest)

# checking for accuracy
table(qualityTest$PoorCare, predictTest > 0.3)
# Accuracy
(19 + 6)/(19+6+5+2)
# Error rate
(5 + 2)/(19+6+5+2)
# Sensitivity
6/8
# Specificity
19/24

# Prediction function
ROCRpredtest = prediction(predictTest, qualityTest$PoorCare)

# Performance function
ROCRperftest = performance(ROCRpredtest, "tpr", "fpr")

# plot
plot(ROCRperftest, colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))

# plot the accuracy
accTest <- performance(ROCRpredtest, measure="acc")
plot(accTest)

# AUC for test data
testDataPred <- roc(qualityTest$PoorCare, predictTest)
auc(testDataPred)
