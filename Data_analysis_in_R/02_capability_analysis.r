# ===============================================
# Introduction to Stats in R
# Module 2: Control charts and capability
# Date: 2023-04-27
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
head(df)

# structure and summary of data
str(df)
summary(df)

# I-MR chart as a function
I_MR <- function(vector) {
    # calculation of moving range
    k <- c(0)
    for (i in 2:length(vector)) {
        k[i-1] <- abs(vector[i]-vector[i-1])
    }
    MR <- sum(k)/length(k)

    # plotting
    par(mfrow = c(1,2)) # 1 row, 2 columns
    # I-chart
    plot(vector, xlab = "Observation", ylab = "Individual value", 
    main = "I chart")
    abline(h = mean(vector), lty = 2)
    abline(h = mean(vector) + 2.66*MR,  col = "#750505")
    abline(h = mean(vector) - 2.66*MR,  col = "#750505")
    # MR chart
    plot(k, xlab = "Observation", ylab = "Range value", main = "MR chart")
    abline(h = MR, lty = 2)
    abline(h = 0, col =  "#750505")
    abline(h = 3.27 * MR, col =  "#750505")
    par(mfrow = c(1,1))
}

I_MR(df$First)

# capability study
# mean value
m <- mean(df$First)
print(m)
# standard deviation
s <- sd(df$First)
print(s)

# calculation of Z value
USL <- 90
LSL <- 45
Zu <- (USL - m)/s
Zl <- (m - LSL)/s

Z <- min(Zu, Zl)
print(Z)

# plotting normal fit
norm_fit <- dnorm(df$First, mean = m, sd = s)
plot(df$First, norm_fit, xlab = "Length [mm]",
    ylab="Density", xlim = c(LSL, USL), main = "Capability analysis")
lines(df$First[order(df$First)], norm_fit[order(df$First)], col = "orange")
abline(v = m, lty = 2)
abline(v = LSL, col="#750505")
abline(v = USL, col="#750505")
grid()
