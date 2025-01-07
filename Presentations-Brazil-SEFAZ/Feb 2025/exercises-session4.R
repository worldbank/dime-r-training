# Data
small_business_2019_all <- read.csv("data/small_business_2019_all.csv")

# Exercise 1a
library(ggplot2)
ggplot(small_business_2019_all) +
  aes(x = taxperiod,
      y = vat_liability) +
  geom_col() +
  labs(title = "Total VAT liability of small businesses in 2019 by month")

# Exercise 1b
ggplot(small_business_2019_all) +
  aes(x = taxperiod,
      y = vat_liability) +
  geom_col() +
  labs(title = "Total VAT liability of small businesses in 2019 by month",
       # x-axis title
       x = "Month",
       # y-axis title
       y = "Georgian Lari") +
  # telling R not to break the x-axis
  scale_x_continuous(breaks = 201901:201912) +
  # centering plot title
  theme(plot.title = element_text(hjust = 0.5))

# Exercise 1c
ggsave("vat_liability_small_2019.png",
       width = 20,
       height = 10,
       units = "cm")

# Exercise 2a
df_group_month <- small_business_2019_all %>%
  select(group, taxperiod, vat_liability) %>%
  group_by(group, taxperiod) %>%
  summarize(total = sum(vat_liability))

# Exercise 2b
ggplot(df_group_month) +
  aes(x = taxperiod,
      y = total) +
  geom_line(aes(color = group)) +
  labs(title = "Total VAT liability of small businesses in 2019 by experiment group",
       x = "Month",
       y = "Georgian Lari") +
  scale_x_continuous(breaks = 201901:201912) +
  theme(plot.title = element_text(hjust = 0.5))

# Exercise 2c
  ggplot(df_group_month) +
    aes(x = taxperiod,
        y = total) +
    geom_line(aes(color = group)) +
    labs(title = "Total VAT liability of small businesses in 2019 by experiment group",
         x = "Month",
         y = "Georgian Lari") +
    scale_x_continuous(breaks = 201901:201912) +
    theme(legend.text = element_text(size = 7),
          axis.text.x = element_text(size = 6))
  
# Exercise 2d
  ggsave("vat_liability_small_2019_by_group.png",
         width = 20,
         height = 10,
         units = "cm")

# Exercise 3a
df_month <- small_business_2019_all %>%
  select(taxperiod, vat_liability) %>%
  group_by(taxperiod) %>%
  summarize(total = sum(vat_liability))

# Exercise 3b
ggplot(df_month) +
  aes(x = taxperiod,
      y = total) +
  geom_col() +
  geom_text(aes(label = total),
            position = position_dodge(width = 1),
            vjust = -0.5,
            size = 3) +
  labs(title = "Total VAT liability of small businesses in 2019 by month",
       x = "Month",
       y = "Georgian Lari") +
  scale_x_continuous(breaks = 201901:201912) +
  theme(plot.title = element_text(hjust = 0.5))

# Exercise 3c
  ggplot(df_month) +
    aes(x = taxperiod,
        y = total) +
    geom_col() +
    geom_text(aes(label = round(total)),
              position = position_dodge(width = 1),
              vjust = -0.5,
              size = 3) +
    labs(title = "Total VAT liability of small businesses in 2019 by month",
         x = "Month",
         y = "Georgian Lari") +
    scale_x_continuous(breaks = 201901:201912) +
    theme(plot.title = element_text(hjust = 0.5))

# Saving
ggsave("vat_liability_small_2019_text.png",
       width = 20,
       height = 10,
       units = "cm")

# Exercise 4
  ggplot(small_business_2019_all) +
    aes(x = age,
        y = vat_liability) +
    geom_point() +
    labs(title = "VAT liability versus age for small businesses in 2019",
         x = "Age of firm (years)",
         y = "VAT liability") +
    theme(plot.title = element_text(hjust = 0.5))

# Saving
  ggsave("scatter_age_vat.png",
         width = 20,
         height = 10,
         units = "cm")
  