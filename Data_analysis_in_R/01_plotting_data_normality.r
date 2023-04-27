# ===============================================
# Introduction to Stats in R
# Module 1: Continuous data display and normality test
# Date: 2023-04-26
#
# ===============================================

# loading required modules
# if you don't have them installed uncomment next two lines
# install.packages("tidyverse")
# install.packages("httpgd")
library("tidyverse")
library("httpgd")

# uploading the dataset
# remember to set the correct working directory
# checking the current working directory
# getwd()
# setting new working directory
# setwd("path to directory")
df <- read.csv("data/sample_data.csv", sep = ";", dec = ",")

# display the head of data
# data includes measurement of the length of three samples
head(df)

# structure and summary of data
str(df)
summary(df)

# Box plot
boxplot(df$First)

# adding more factors
boxplot(df$First, df$Second, df$Third)

# adding labels to axes
boxplot(df$First, df$Second, df$Third, names=c("First sample", "Second sample", "Third sample"), 
    xlab = "Sample order", ylab = "Length [mm]", main = "Boxplots of lenghts of samples")

# histogram of data
hist(df$First)

# controlling bins, color and labels
hist(df$First, breaks = 10, xlab = "Length [mm]", 
    main = "Histogram of length measurements of the first sample", col = "lightblue")

# normality test if p > 0.05 data is normal
shapiro.test(df$First)
# plotting the points
qqnorm(df$First)
qqline(df$First, col="#750505")

# mean value
m <- mean(df$First)
print(m)
# standard deviation
s <- sd(df$First)
print(s)

# plotting normal fit
norm_fit <- dnorm(df$First, mean = m, sd = s)
plot(df$First, norm_fit, xlab = "Length [mm]",
    ylab="Density")
lines(df$First[order(df$First)], norm_fit[order(df$First)], col = "orange")
grid()
