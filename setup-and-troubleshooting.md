# Troubleshooting and setup

## Setup needed for sessions 3-7:

1. Please ensure that you are able to follow these instructions **before the start of the sessions**.

    + If you completed the RStudio projects exercise of session 2: instructions [here](https://raw.githack.com/worldbank/dime-r-training/master/Presentations/03-data-wrangling.html?panelset=if-you-attended-session-2#4)
    + If you did not attend session 2: instructions [here](https://raw.githack.com/worldbank/dime-r-training/master/Presentations/03-data-wrangling.html?panelset=if-you-did-not-attend-session-2#4)

2. Try loading the following packages depending on the sessions you will attend **before the sessions**. If you don't have the packages installed, install using `install.packages("package-name")`. If you do not know what package loading or installation is, you will have to check the recording of [session 1](https://osf.io/yausg) and [session 2](https://osf.io/uqa6m), otherwise you will not be able to follow the contents of sessions 3-7.
    + Used in all sessions: `tidyverse`, `here`
    + Data wrangling: `janitor`
    + Descriptive analysis: `huxtable`, `modelsummary`, `lfe`, `openxlsx`, `skimr`
    + Geospatial data: `sf`, `rworldmap`, `ggmap`, `wesanderson` (that's the actual name)
    + Introduction to R markdown: `tinytex`, `stargazer`, `huxtable`
    + Data visualization: no additional packages needed

## Troubleshooting

Please refer to the instructions below to troubleshoot any errors you might for the setup.

### Package not yet installed
If you get an error with the message:
```
Error in ...: `there is no package called ...`
```
when trying to load a package with `library()`, that means that the package is not installed in your computer yet. Use `install.packages("package-you-tried")` and try again. Note that you usually refer to the package name with double quotes when installing, but without quotes when loading.

### Function not found
If you try a function and get an error with the message:
```
 Error in ...: `could not find function ...`
 ```
 That can mean that you have a typo or that you are calling a function from a package that you have not loaded yet. Use `library()` to make sure the corresponding package is loaded and try again.

### WB firewall rejection the installation of packages
If you try to install a package  in a WB computer and get a large message in which **the last two lines** says something similar to:
```
unable to access index for repository https://cran.rstudio.com/bin/windows/[URL continues]
cannot open URL 'https://cran.rstudio.com/bin/windows/[URL continues]
```
then the issue is probably that the WB firewall rejected your connection to the URL to install the package. Follow [these instructions](https://github.com/worldbank/dime-r-training/issues/105) to solve the issue.
