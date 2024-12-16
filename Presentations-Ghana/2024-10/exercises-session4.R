# Data
employees_by_department <- read.csv("data/employees_by_department.csv")

# Exercise 1a
library(ggplot2)

ggplot(employees_by_department) +
  aes(x = department,
      y = number) +
  geom_col() +
  labs(title = "Number of employees by department, 2024")

# Exercise 1b
ggplot(employees_by_department) +
  aes(x = department,
      y = number) +
  geom_col(fill = "#9370DB") +
  labs(
    title = "Number of employees by department, 2024",
    # x-axis title
    x = "Department",
    # y-axis title
    y = "Number"
  ) +
  # Centering plot title
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1) # Rotating x-axis labels
  )
# Exercise 1c

ggplot(employees_by_department) +
  aes(x = reorder(department, -number), y = number) + #<<  # Reorder bars by `number`
  geom_col(fill = "#9370DB") +
  geom_text( #<< 
    aes(label = number), #<< 
    angle = 90 #<< 
  ) + #<< 
  labs(
    title = "Number of employees by department, 2024",
    x = "Department",
    y = "Number"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1) # Rotate x-axis labels
  )

# Exercise 1d
ggsave("employees_by_department.png",
       width = 20,
       height = 10,
       units = "cm")

# Exercise 2a

ggplot(employees_by_department) +
  aes(x = "", y = number, fill = department) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(
    title = "Proportion of employees by department, 2024"
  ) +
  theme_void()

# Exercise 2b 

ggplot(employees_by_department) +
  aes(x = "", y = number, fill = department) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(
    title = "Proportion of employees by department, 2024"
  ) +
  theme_void() +
  scale_fill_viridis_d(option = "D")

#Exercise 2c

ggsave("employees_by_department_pie.png")

