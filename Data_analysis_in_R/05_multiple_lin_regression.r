# ===============================================
# Introduction to Stats in R
# Module 5: multiple linear regression
# Date: 2023-08-03
#
# ===============================================

# loading required modules
library("tidyverse")
library("httpgd")

# uploading the dataset
df <- read.csv("data/multiple_reg.csv", sep = ";", dec = ",")

# display the head of data
head(df)

# structure and summary of data
str(df)
summary(df)

# plot to see any correlations
library(corrplot)
M <- cor(df)
corrplot.mixed(M)

# creation of the regression model
reg_model = lm(Y ~ ., data = df)

# display regression model summary
summary(reg_model)

# residuals
resi <- reg_model$residuals

# fits
fits <- reg_model$fitted.values

# checking of the model

# checking for normality of residuals
shapiro.test(resi)

# plotting all together
par(mfrow = c(2,2)) # 2 rows, 2 columns
plot(reg_model, which = 2) # normal plot of resi
hist(resi, breaks = 7)
plot(reg_model, which = 1) # residuals vs. fits
par(mfrow = c(1,1)) # 1 row, 1 column

# second order regression model

reg_model2 <- lm(Y ~ X1 + X2 + X3 + X4 + I(X1^2) + I(X2^2) +
    I(X3^2) + I(X4^2) + I(X1*X2) + I(X1*X3) + I(X1*X4) +
    I(X2*X3) + I(X2*X4) + I(X3*X4), data = df)

summary(reg_model2)

# plotting resi and fits for the second regression model
# residuals
resi2 <- reg_model2$residuals

# fits
fits2 <- reg_model2$fitted.values

# plotting all together
par(mfrow = c(2,2)) # 2 rows, 2 columns
plot(reg_model2, which = 2) # normal plot of resi
hist(resi2, breaks = 7)
plot(reg_model2, which = 1) # residuals vs. fits
par(mfrow = c(1,1)) # 1 row, 1 column

# investigation of Y
# histogram of Y
hist(df$Y, breaks = 15)
hist(log(df$Y), breaks = 15)

reg_model3 <- lm(log(Y) ~ X1 + X2 + X3 + X4 + I(X1^2) + I(X2^2) +
    I(X3^2) + I(X4^2) + I(X1*X2) + I(X1*X3) + I(X1*X4) +
    I(X2*X3) + I(X2*X4) + I(X3*X4), data = df)

summary(reg_model3)

# plotting resi and fits for the second regression model
# residuals
resi3 <- reg_model3$residuals

# fits
fits3 <- reg_model3$fitted.values

# plotting all together
par(mfrow = c(2,2)) # 2 rows, 2 columns
plot(reg_model3, which = 2) # normal plot of resi
hist(resi3, breaks = 7)
plot(reg_model3, which = 1) # residuals vs. fits
par(mfrow = c(1,1)) # 1 row, 1 column

# finetuning the model - getting rid of X4^2 (highest p-value)
reg_model4 <- lm(log(Y) ~ X1 + X2 + X3 + X4 + I(X1^2) + I(X2^2) +
    I(X3^2) + I(X1*X2) + I(X1*X3) + I(X1*X4) +
    I(X2*X3) + I(X2*X4) + I(X3*X4), data = df)

summary(reg_model4)

# plotting resi and fits for the second regression model
# residuals
resi4 <- reg_model3$residuals

# fits
fits4 <- reg_model3$fitted.values

# plotting all together
par(mfrow = c(2,2)) # 2 rows, 2 columns
plot(reg_model4, which = 2) # normal plot of resi
hist(resi4, breaks = 7)
plot(reg_model4, which = 1) # residuals vs. fits
par(mfrow = c(1,1)) # 1 row, 1 column
