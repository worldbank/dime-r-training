# Exercise 2
x1 <- 100
x2 <- 50
x3 <- x1 + x2
print(x3)

# Exercise 4
df_pelotas <- subset(small_business_2019_br,
                   region == "Pelotas")
View(df_pelotas)

# Exercise 5
v1 <- c(3, 8, 10)
v2 <- c(7, 2, 5)
result1 <- v1 + v2
result2 <- v2 + 10
print(result1)
print(result2)

# Exercise 6
summary_table <- summary(small_business_2019_br)
print(summary_table)