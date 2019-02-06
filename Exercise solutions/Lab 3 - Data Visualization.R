# ------------------------------------------------------------------------------ #

#                                                                                #

#                                     DIME                                       #

#                          Data Visualization in R                               #

#                                                                                #

# ------------------------------------------------------------------------------ #

# Set up ----------------------------------------------------------------------
# install plotly and ggplot
install.packages("plotly",
                 dependencies = T)
install.packages("ggplot",
                 dependencies = T)
# load plotly and ggplot
library(plotly)
library(ggplot2)
# load data
whr <- read.csv("~/GitHub/dime-r-training/DataWork/Datasets/Final/whr_panel.csv",
                header = T,
                stringsAsFactors = F)
### Exercise 1
# vectors with covariates 
covariates <- c("happy_score",
                "gdp_pc",
                "freedom",
                "trust_gov_corr")
# subset whr
whr_simp <- whr[, covariates]
# plot whr_simp
plot(whr_simp)

### Exercise 2
hist(whr_simp$happy_score, col = "green")

### Exercise 3
boxplot(whr$happy_score ~ whr$region, las = 2)

### exercise 4
p1_happyfree <- 
  ggplot(whr,
         aes(y = happy_score,
             x = freedom)) +
  geom_point()
print(p1_happyfree)

### exercise 5
annualHappy<-
  aggregate(happy_score ~ year,
            data = whr,
            FUN = mean)

p2_happyyear <-
  ggplot(data = annualHappy, 
         aes(y = happy_score,
             x = year)) +
  geom_line()

print(p2_happyyear)

### exercise 6 - 1
annualHappy_reg <-
  aggregate(happy_score ~ year + region,
            data = whr,
            FUN = mean)
annualHappy_reg[1:10,]

### exercise 6 - 2
annualHappy_reg <-
  aggregate(happy_score ~ year + region,
            data = whr,
            FUN = mean)
p3_happyreg <-
  ggplot(data = annualHappy_reg, 
         aes(y = happy_score,
             x = year, 
             color = region, 
             group = region)) +
  geom_line() +
  geom_point()
print(p3_happyreg)

### exercise 7 - 1
whr17 <- whr[whr$year == 2017, ]

p5_happyfree17 <-
  ggplot(whr17, aes(x = freedom,
                    y = happy_score)) +
  geom_point()

print(p5_happyfree17)

### exercise 7 - 2
p6_happyfree17reg <- 
  ggplot(whr17, 
         aes(x = freedom,
             y = happy_score)) +
  geom_point(aes(color = factor(region)))

print(p6_happyfree17reg)

### exercise 7 - 3
p6_happyfree17reg <-
  ggplot(whr17, 
         aes(x = freedom,
             y = happy_score)) +
  geom_point(aes(color = factor(region),
                 size = gdp_pc))
print(p6_happyfree17reg)

### exercise 8
p6_happyfree17reg <-
  p6_happyfree17reg +
  ggtitle("My pretty plot") +
  xlab("Freedom") +
  ylab("Happiness") +
  scale_color_discrete(name = "World Region") +
  scale_size_continuous(name = "Score of GDP per capita")

print(p6_happyfree17reg)

### exercise 9
Output <- "~/GitHub/dime-r-training/DataWork/Output"
pdf(file = file.path(Output, "plot1.pdf"))

print(p6_happyfree17reg) 

dev.off()

### exercise 10
library(plotly)
ggplotly(p6_happyfree17reg, tooltip = c("country", "gdp_pc", "freedom", "happy_score"))
  
