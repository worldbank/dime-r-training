# LAB 1 EXERCISES ##################################

# Exercise 1 ---------------------------------------

# Create the individual objects
me <- "Luiza"
left <- "Leonardo"
right <- "Guillaume"

# Print them
print(me) # Using the print function
left # Using the print shortcut
right

# Exercise 2 ------------------------------------------

# Create individual scalars
me_sib <- 1
left_sib <- 1
right_sib <- 5

# Print the objects
me_sib
left_sib
right_sib

# Exercise 3 ----------------------------------------

age_young <- c(25, 26, 19)

# Exercise 4 ----------------------------------------

# One way of doing it
siblings <- c(1, 1, 5)
siblings

# Other way of doing it
siblings <- c(me_sib, left_sib, right_sib)
siblings
class(siblings) # c() creates vectors

# Yet another way
siblings <- rbind(me_sib, left_sib, right_sib)
siblings
class(siblings) # rbind creates a matrix

# Exercise 5 ---------------------------------------

name <- c(me, left, right)
class(name)

# Exercise 6 ---------------------------------------

# Create the vector
c <- c(name, siblings)

# Print the vector
c

# What kind of data?
class(c) 
# Combining strings and number in the same object will 
# force the numbers to became strings 

# Exercise 7 ---------------------------------------

# Create the data frame
siblings.df <- data.frame(name, siblings, age_young)

# What's in it?
str(siblings.df) # Name is now a factor!

# Make it a string:
siblings.df$name <- as.character(siblings.df$name)

# This is better!
class(siblings.df$name)


# Exercise 8 ---------------------------------------

# One way of doing it
siblings.df$gender <- factor(c(1, 1, 1),
                             levels = c(1,2),
                             labels = c("Female", "Male"))

# Another way of doing it
siblings.df$gender <- factor(c("Female", "Female", "Female"))

# Exercise 9 ---------------------------------------

# Create the boolean
siblings.df$age_low <- siblings.df$age_young < mean(siblings.df$age_young)

# Check that it has the right class
str(siblings.df)

# Print it
print(siblings.df$age_low)

# Exercise 10 --------------------------------------

# Subset
siblings.df.subset <- siblings.df[siblings.df$age_low == TRUE, ]

# Which is the same as
siblings.df.subset <- siblings.df[siblings.df$age_low, ]

# It's also the same as
siblings.df.subset <- subset(siblings.df, age_low == TRUE)

# Check the new data set
siblings.df.subset

# Exercise 11 --------------------------------------

# Complete sample
summary(siblings.df)

# Restricted sample
summary(siblings.df.subset)

# Exercise 12 --------------------------------------

# Open help file
help(data.frame)

# This is how we'd use the stringsAsFactors option
siblings.df <- data.frame(name, siblings, age_young,
                          stringsAsFactors = FALSE)