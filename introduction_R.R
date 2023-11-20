#====================================
#     R Programming foundations
#====================================
#     ___  ___  _____  ___  
#    (   )/ _ \|  ___)/ _ \ 
#     | || |_| | |_  | |_| |
#     | ||  _  |  _) |  _  |
#     | || | | | |___| | | |
#    (___)_| |_|_____)_| |_|
#====================================
#        Luis Fernando Delgado
#====================================

# Clear the entire workspace
rm(list = ls())

# Accessing Help in R
help()
help(sd) # Get help about the standard deviation function
?mean # Get help about the mean function
?round()

help.search("regression")
??regression

# Setting a seed number for reproducibility
set.seed(123)
random_numbers <- sample(100:999, 8)
random_numbers

# Creating a sequence of numbers with the seq function
w <- seq(from = 1, to = 100, by = 3)
w

# Working with objects
# Creating a numeric object
x <- c(1, 2, 3, 4, 5)
x

# Checking the class of an object
class(x)

# Creating a character object
x1 <- c("1", "2", "3", "4", "5")
x1
class(x1)

# Removing an object from the workspace
rm(x1)

# Performing basic numeric operations
# Addition
2 + 2

# Subtraction
3 - 4

# Multiplication
4 * 6

# Exponentiation
2^3

# Equality operators
3 == 3

# Greater Than or Equal
4 >= 2
4 >= 5

# Greater than
5 > 1

# Less Than or Equal
7 <= 10

# Not equal
1 != 2

# Working with factors - Converting character vectors into factors
x <- c("A", "B", "A", "C", "A", "C")
class(x)

# Converting into a factor
fx <- factor(x)
fx
class(fx)
levels(fx) # Identifying the levels of the factor vector

# Creating a frequency table
table(fx)

# Accessing specific vector elements with "[ ]"
x <- c(1, 2, 56, 78, 5, 47, 7, 8)

# Accessing the fourth position of vector "x"
x[4]

# Accessing all elements except the fifth
x[-5]

# Accessing the third and sixth elements
x[c(3, 6)]

# Accessing elements from the fifth to eighth
x[5:8]

# Accessing elements greater than 3
x[x > 3]

# Working with matrices
x <- c(1, 2, 3, 4, 5, 6) # Numerical vector
x1 <- c(1.2, 1.3, 1.8, 2.9, 10.5, 0.9) # Numerical vectors
y <- c("Sarah", "Tracy", "Jon", "Marcio", "Felipe", "Matias") # Vector of characters
z <- c(TRUE, TRUE, FALSE, FALSE) # Logical vector

# Creating a matrix from numeric vectors
m1 <- matrix(c(x, x1), 6, 2)
m1

# Working with lists
# Creating a list containing vectors
my_list <- list(x = x, x1 = x1, y = y, z = z)
my_list
names(my_list)
my_list$x1

# Working with dataframes
# Example in Genomics
x <- c("snp1", "snp2", "snp3", "snp4", "snp5", "snp6")
y <- c(1, 1, 2, 2, 3, 3)
z <- c(10, 20, 100, 400, 150, 200)
ind1 <- c("AA", "AA", "aa", "Aa", "aa", "AA")
ind2 <- c("AA", "AA", "aa", "Aa", "AA", "AA")
ind3 <- c("Aa", "AA", "aa", "Aa", "Aa", "aa")
ind4 <- c("aa", "AA", "Aa", "aa", "AA", "AA")

# Creating a dataframe
snp_data <- data.frame(name = x, chr = y, pos = z, ind1, ind2, ind3, ind4)
snp_data

# Getting the dimensions of the dataset
dim(snp_data)

# Subsetting the data [row, col]
snp_data[1,] # Selecting the first row
snp_data[, 4] # Selecting the column for ind1
snp_data[, -2] # Deleting the chr column
snp_data[, 4:7] # Selecting only the columns for individuals

# Subsetting data using the dplyr package
# install.packages("dplyr")
library(dplyr)
snp_data %>% filter(chr == 1) # Selecting only rows where chr equals 1
snp_data %>% filter(chr == 2 & pos == 100) # Selecting rows where chr equals 2 and pos equals 100
snp_data %>% select(name, chr, pos) # Selecting specific columns: name, chr, and pos


# Exercises
# Access elements Less Than or Equal 70 in vector "x"
# x[x  70]

# Access elements not equal to 100
# x[x  100]

# Access elements equal to 47
# x[x  47]

# Suppose you have a vector x with the following values: "A", "B", "A", "C", 
# "A", "C". Convert this vector into a factor and store it in a variable fx. 
# Then, create a frequency table for fx to count the occurrences of each factor level.

# Consider the snp_data dataframe created in the code. Write R code to 
# accomplish the following tasks:
  
  # a. Extract the rows from snp_data where the chromosome (chr) is equal to 2.

  # b. Extract the rows from snp_data where the chromosome (chr) is equal to 3 
  # and the position (pos) is equal to 150.

  # c. Create a new dataframe snp_subset containing only the columns name, 
  # ind1, and ind2 from snp_data.

