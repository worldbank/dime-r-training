# Solution Script for Session 1: Introduction to R 

# Exercise 1: writing code in the console. 
# This was not saved in the script 
# As we only did it in the console
# This is how we add comments on R, that way we can write our 
# code and explain what are we trying to do at each step.

# Exercise 2: creating an object
x1 <- 100
x2 <- 50
x3 <- x1 + x2
x3

# Exercise 3: Using a function sum()
# here we use the function sum to sum numbers from 1 to 10 consecutevely
sum_exercise <- sum(c(1:10))
print(sum_exercise)

# Exercise 4: load data into R
# In the training we followed the point and click approach the steps are: 
# file> import from text base> select the file 

# but do you remember that we saw the function behind in the R console? 
# I am adding it here: 
# Note: the argument the read.csv function takes is the path were the data is 
# stored in my computer. In my case is in the data folder, in your it might be 
# downloads. 
department_staff_list <- read.csv("data/department_staff_list.csv")

# Exercise 5: find the unique departments in our list
unique_departments <- unique(department_staff_list$department)
