# ===============================================
# Introduction to Stats in R
# Module 3: hypothesis testing
# Date: 2023-05-07
#
# ===============================================

# loading required modules
# if you don't have them installed uncomment the next line
# install.packages("httpgd")
# install.packages("tidyverse")
library("httpgd")
library("tidyverse")

# uploading the dataset
df <- read.csv("data/hypothesis_testing.csv", sep = ";", dec = ",")

# display the head of data
head(df)

# structure and summary of data
str(df)
summary(df)

# 1. One sample t-test
# ==========================
M <- df$Sample_1

# normality test
shapiro.test(M)

# check if the sample mean is 55
t.test(M, mu = 55)

# check if the sample mean is 52
t.test(M, mu = 52)

# 2. Two sample t-test
# ==========================

# cleaning data to drop NA
df2 <- df[2:3] %>% drop_na()

# sample 1
s1 <- df2$Sample_2
# sample 2
s2 <- df2$Sample_3

# Step A - stability of data

# I-MR chart function
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
    plot(vector, xlab = "Observation", ylab = "Individual value", main = "I chart")
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

I_MR(s1)
I_MR(s2)

# Step B - checking for normality
shapiro.test(s1)
shapiro.test(s2)
par(mfrow = c(2,2))
qqnorm(s1)
qqline(s1, col="#750505")
qqnorm(s2)
qqline(s2, col="#750505")
hist(s1, col = "steelblue", breaks = 15)
hist(s2, col = "steelblue", breaks = 15)
par(mfrow = c(1,1))

# Step C - checking for equal variances
# F-test
var.test(s1, s2)

# Step D - checking centering
t.test(s1, s2, var.equal = TRUE)

boxplot(s1, s2, col="steelblue")
