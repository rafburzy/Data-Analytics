# ===============================================
# Introduction to Stats in R
# Module 4: linear regression
# Date: 2023-05-30
#
# ===============================================

# loading required modules
library("tidyverse")
library("httpgd")

# uploading the dataset
df <- read.csv("data/lin_reg.csv", sep = ";", dec = ",")

# display the head of data
head(df)

# structure and summary of data
str(df)
summary(df)

# X = hours studied, Y = exam grade

# plot of the two variables
plot(df$X, df$Y)

# adding all the additional information
plot(df$X, df$Y, xlab = "Hours studied", ylab = "Exam result", 
    main = "Scatterplot for relation of exam result to hours studied")
points(df$X, df$Y, pch = 23, bg = "lightblue", cex = 1.2)
grid()

# creation of the regression model
reg_model <- lm(Y ~ ., data = df)

# display regression model summary
summary(reg_model)

# residuals
resi <- reg_model$residuals

# fits
fits <- reg_model$fitted.values

# checking of the model
# histogram of residuals
hist(resi, breaks = 5)

# checking for normality of residuals
shapiro.test(resi)
qqnorm(resi)
qqline(resi, col="#750505")

# resi vs fits
plot(fits, resi)
points(fits, resi, pch = 23, bg = "lightyellow", cex = 1.2)
abline(h = 0, lty = 2)
grid()

# plot of residuals vs order
plot(resi, type = "l")
points(resi)
abline(h = 0, lty = 2)
grid()

# ============================================
## Additional way to plot the same items
plot(reg_model)

# limited to interactions
par(mfrow = c(1,2)) # 1 row, 2 columns
plot(reg_model, which = 1) # residuals vs. fits
plot(reg_model, which = 2) # normal plot of resi
par(mfrow = c(1,1))

# =============================================

# plotting the regression line
plot(df$X, df$Y, xlab = "Hours studied", ylab = "Exam result", 
    main = "Regression line for exam result vs. hours studied")
points(df$X, df$Y, pch = 23, bg = "lightblue", cex = 1.2)
grid()
abline(a = reg_model$coefficients[1], b =  reg_model$coefficients[2])

