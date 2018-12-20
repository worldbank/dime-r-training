

# for (year in 2015:2017) {
#   download.file(paste0("https://www.kaggle.com/unsdsn/world-happiness/downloads/", year ,".csv/2"),
#                 destfile = file.path(Data,paste0("Raw/WHR", year, ".csv")), 
#                 method = "curl") # method = "curl" [mac only for https]
#   
# }

dateDownloaded <- date()

whr15 <- read.csv(file.path(Data,"Raw/WHR2015.csv"),
                  header = T,
                  stringsAsFactors = F)
whr16 <- read.csv(file.path(Data,"Raw/WHR2016.csv"),
                  header = T,
                  stringsAsFactors = F)
whr17 <- read.csv(file.path(Data,"Raw/WHR2017.csv"),
                  header = T,
                  stringsAsFactors = F)
View(whr15)
class(whr15)
dim(whr15)
str(whr15)
head(whr15)
summary(whr15)


str(whr15)
str(whr16)
str(whr17)

n_distinct(whr15$Country, na.rm = TRUE)
n_distinct(whr16$Country, na.rm = TRUE)
n_distinct(whr17$Country, na.rm = TRUE)

setdiff(whr15$Country, whr16$Country)
setdiff(whr16$Country, whr15$Country)
setdiff(whr16$Country, whr17$Country)
setdiff(whr17$Country, whr16$Country)


whr15$Country[whr15$Country == "Somaliland region"]         <- "Somaliland Region" 
whr17$Country[whr17$Country == "Hong Kong S.A.R., China"]   <- "Hong Kong" 
whr17$Country[whr17$Country == "Taiwan Province of China"]  <- "Taiwan" 


names(whr15)
names(whr16)


whr15$year <- 2015
whr16$year <- 2016
whr17$year <- 2017

whr_panel <- rbind(whr15, whr16, whr17)
whr_panel <- bind_rows(whr15, whr16, whr17)

setdiff(names(whr15), names(whr16))
setdiff(names(whr16), names(whr15))
setdiff(names(whr17), names(whr16))
setdiff(names(whr16), names(whr17))

whr17 <- rename(whr17, 
              Lower.Confidence.Interval = Whisker.low,
              Upper.Confidence.Interval = Whisker.high)

whr_panel <- rbind(whr15, whr16, whr17)
whr_panel <- bind_rows(whr15, whr16, whr17)



keepVars <-   c("Country",
                "Region",
                "year",
                "Happiness.Rank",
                "Happiness.Score",
                "Economy..GDP.per.Capita.", 
                "Family",
                "Health..Life.Expectancy.",
                "Freedom",
                "Trust..Government.Corruption.",
                "Generosity",
                "Dystopia.Residual")

whr15 <- select(whr15, keepVars)
whr16 <- select(whr16, keepVars)

regions <- select(whr16, Country, Region)


whr17 <- left_join(whr17, regions)
whr17 <- select(whr17, keepVars)

whr_panel <- rbind(whr15, whr16, whr17)

names(whr_panel) <-  c("country",
                       "region",
                       "year",
                       "happy_rank",
                       "happy_score",
                       "gdp_pc",
                       "family",
                       "health",
                       "freedom",
                       "trust_gov_corr",
                       "generosity",
                       "dystopia_res")


any(is.na(whr_panel$region))
sum(is.na(whr_panel$region))
whr_panel$country[is.na(whr_panel$region)]

whr_panel$region[whr_panel$country == "Mozambique"]               <- "Sub-Saharan Africa"
whr_panel$region[whr_panel$country == "Lesotho"]                  <- "Sub-Saharan Africa"
whr_panel$region[whr_panel$country == "Central African Republic"] <- "Sub-Saharan Africa"

any(is.na(whr_panel$region))

str(whr_panel$region)
whr_panel$region_cat <- as.factor(whr_panel$region)
str(whr_panel$region_cat)
levels(whr_panel$region_cat)
table(whr_panel$region_cat)

whr_panel$region_ord <- factor(whr_panel$region,
                     levels = c("Australia and New Zealand",
                                "Central and Eastern Europe",
                                "Western Europe",
                                "Latin America and Caribbean",
                                "North America",
                                "Southeastern Asia",
                                "Southern Asia",
                                "Eastern Asia",
                                "Middle East and Northern Africa",
                                "Sub-Saharan Africa"),
                     ordered = T)
table(whr_panel$region_ord)

whr_panel <- mutate(whr_panel, happy_high = happy_score > median(happy_score))

whr_panel$happy <- factor(whr_panel$happy_high,
                         levels = c(FALSE, TRUE),
                         labels = c("Not so happy", "Happy"))

happy_panel <- filter(whr_panel, happy == "Happy")

# Reshaping
whr_happy <- select(whr_panel, country, region, year, happy)

whr_happy_wide <- spread(whr_happy,
                         key = year,
                         value = happy)

whr_happy_long <- gather(whr_happy_wide,
                         key = year,
                         value = happy,
                         `2015`, `2016`, `2017`)

whr_happy <- select(whr_panel, country, region, year, happy, happy_score)

whr_hapy_reshape <- reshape(whr_happy,
                            v.names = "year",
                            )