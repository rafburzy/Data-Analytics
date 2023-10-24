# ===============================================
# Introduction to Stats in R
# Module 7: Chi-square test
# Date: 2023-09-24
#
# ===============================================

# loading required libraries
library("httpgd")
library("tidyverse")

# 1. Goodness of fit test

throws <- c(62, 38)
expectation <- c(.5, .5) # probabilities must sum to 1

chisq.test(x=throws, p=expectation)

# 2. Test for independence

# preparation of the dataset
scratches <- c(120, 35, 48, 32, 89, 105, 11, 47, 111, 34, 58, 33)
t <- matrix(scratches, nrow=3, byrow = TRUE)
colnames(t) <- c("Category 1", "Category 2", "Category 3", "Category 4")
rownames(t) <- c("Sample A", "Sample B", "Sample C")
t

# test for independence for three samples
chisq.test(t)

# preparation of the table of samples A and B

t_ab <- matrix(c(t[1,], t[2,]), nrow=2, byrow = TRUE)
colnames(t_ab) <- c("Category 1", "Category 2", "Category 3", "Category 4")
rownames(t_ab) <- c("Sample A", "Sample B")
t_ab

# test for independence for samples A and B
chisq.test(t_ab)

# preparation of the table of samples A and C

t_ac <- matrix(c(t[1,], t[3,]), nrow=2, byrow = TRUE)
colnames(t_ac) <- c("Category 1", "Category 2", "Category 3", "Category 4")
rownames(t_ac) <- c("Sample A", "Sample C")
t_ac

# test for independence for samples A and C
chisq.test(t_ac)

# preparation of the table of samples B and C

t_bc <- matrix(c(t[2,], t[3,]), nrow=2, byrow = TRUE)
colnames(t_bc) <- c("Category 1", "Category 2", "Category 3", "Category 4")
rownames(t_bc) <- c("Sample B", "Sample C")
t_bc

# test for independence for samples B and C
chisq.test(t_bc)
