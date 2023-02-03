##### Simple data analysis and more complex control structures
##### 30 january 2023
##### PPW TDW

dryadData <- read.table(file = "data/veysey-babbitt_data_amphibians.csv", header = TRUE, sep = ",")

## set up libraries
library(tidyverse)
library(ggthemes)

### Analyses 
### Experimental design
### independent/explanatory variable (x-axis) vs dependent/response variable (y-axis)
### continuous variables (range of numbers: height, weight, temp) vs discrete/categorical variables (categories: species, treatment groups, site)

## both continuous: linear regression [scatter plot]
## both categorical: chi-squared (count data) [table, mosaic plot]
## x=cat, y=cont: t-test (2-groups) or ANOVA (2+) [bar graphs, box plots]
## x=cont, y=cat: logistic regression [regression curve/plot?]

glimpse(dryadData)

### basic linear regression analysis (2 continuous variables)
## is there a relationship between the mean pool hydroperiod and the number of breeding frogs caught?
## y ~ x 
regModel <- lm(count.total.adults ~ mean.hydro, data=dryadData)

print(regModel)
summary(regModel) #estimate=slope, below is it the p-value
hist(regModel$residuals) #visualizes 
summary(regModel)$"r.squared" # returns just r.squared
summary(regModel)[["r.squared"]] # does the same thing

View(summary(regModel)) # has to be capital V, rmarkdown doesn't like so don't leave

regPlot <- ggplot(data=dryadData, aes(x=mean.hydro, y=count.total.adults)) +
  geom_point(size=2) +
  stat_smooth(method="lm", se=0.99)

regPlot + theme_few()

### basic ANOVA
### was there a statistically significant difference in the number of adults among wetlands?
ANOmodel <- aov(count.total.adults ~ factor(wetland), data=dryadData) # factor() made wetland categorical
summary(ANOmodel)

dryadData %>%
  group_by(factor(wetland)) %>%
  summarize(avgHydro = mean(count.total.adults, na.rm = T), N = n())

### boxplot
dryadData$wetland <- factor(dryadData$wetland)
class(dryadData$wetland)

ANOplot2 <- ggplot(data=dryadData, mapping=aes(x=wetland, y=count.total.adults, fill= species)) +
  geom_boxplot() +
  scale_fill_grey()
ANOplot
ANOplot2
##ggsave(file="SpeciesBoxplots.pdf", plot = ANOplot2, device = "pdf") #saves image as file


### Logistic Regression
## data frame
# gamma probabilities are best for continuous variables that are always positive and have a skewed distribution 
xVar <- sort(rgamma(n=200, shape = 5, scale = 5))
yVar <- sample(rep(c(1,0), each = 100), prob = seq_len(200))
logRegData <- data.frame(xVar, yVar)

### Logistic regression analysis
logRegModel <- glm(yVar ~ xVar, 
                   data = logRegData,
                   family = binomial(link = logit))
summary(logRegModel)

logRegPlot <- ggplot(data=logRegData,
                     aes(x=xVar, y=yVar)) +
  geom_point() +
  stat_smooth(method="glm", method.args = list(family=binomial))
logRegPlot


### Contingency table (chi-squared) Analysis
### Are there differences in counts of males and females between species?

countData <- dryadData %>%
  group_by(species) %>%
  summarize(Males = sum(No.males, na.rm = T), Females = sum(No.females, na.rm = T)) %>%
  select(-species) %>%
  as.matrix()
countData

row.names(countData) = c("SS", "WF")

## chi-squared
testResults <- chisq.test(countData)
testResults$residuals #tells you value compared to expected 


#### mosaic plot (base R)
mosaicplot(x=countData,
           col=c("goldenrod", "grey"),
           shade = FALSE)

### bar plot 

countDataLong <- countData %>%
  as_tibble() %>%
  mutate(Species = c(rownames(countData))) %>% ##makes species a column instead of row titles
  pivot_longer(cols = Males:Females, names_to = "Sex", values_to = "Count")

### plot bar graph
ggplot(countDataLong, aes(x=Species, y=Count, fill=Sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("darkslategrey", "midnightblue"))


#########################################################
#### Control Structures

# if and ifelse statements
#### if (condition) {expression 1}

#### if (condition) {expression 1} else {expression 2}

#### if (condition 1) {expression 1} else 
#### if (condition 2) {expression 2} else
#### {expression 3}
### if any final unspecified else captures the rest of (unspecified) conditions
# else must appear on the same line as the expression

# use it for single values
z <- signif(runif(1), digits = 2)
#z > 0.5

### use {} or not
## have to run each line at a time
if (z>0.8) {cat(z, "is a large number", "\n")} else 
  if (z<0.2) {cat(z, "is a small number", "\n")} else 
  {cat(z, "is a number of typical size", "\n")
    cat("z^2 =", z^2, "\n")}

#### ifelse to fill vectors

### ifelse(condition, yes, no)

### insect population where the females lay 10.2 eggs on average, follows Poisson distribution (discrete probability distribution showing the likely number of times an event will occur). 35% parasitism where no eggs are laid. Let's make a distribution for 1000 individuals

tester <- runif(1000)
eggs <- ifelse(tester > 0.35, rpois(n=1000, lambda = 10.2), 0)
hist(eggs)

#### vector of p-values from a simulation and we want to create a vector to highlight the significant ones for plotting
pVals <- runif(1000)
z <- ifelse(pVals <= 0.025, "lowerTail", "nonSig")
z
z[pVals >= 0.975] <- "upperTail"
table(z)


###### for loops
### workhorse function for doing repetitive tasks
### universal in all computer languages
### Controversial in R 
### - often not necessary (vectorization in R exists)
### - very slow with certain operations
### - family of apply functions

### Anatomy of for loop
## for(variable in seq){ #starts for loop
# body of for loop
#}
# var is a counter variable that holds the current value of the loop (i, j, k)
# sequence is an integer vector that defines start/end of loop

for (i in 1:5) {
  cat("stuck in a loop", i, "\n")
  cat(3+2, "\n")
  cat(3+i, "\n")
}

print(i) #equals 5 because thats the end of the loop 

### use a counter variable that maps to the position of each element 
my_dogs <- c("chow", "akita", "malamute", "husky", "samoyed")
for (i in 1:length(my_dogs)) {
  cat("i=", i, "my_dogs[1]=", my_dogs[i], "\n")
}

#### use double for loop

## loop over rows 
m <- matrix(round(runif(20), digits = 2), nrow = 5)

for (i in 1:nrow(m)) {
  m[i,] <- m[i,] + i
}

## loop over columns
m <- matrix(round(runif(20), digits = 2), nrow = 5)

for (j in 1:col(m)) {
  m[,j] <- m[,j] + j
}


## loop over rows and columns 
m <- matrix(round(runif(20), digits = 2), nrow = 5)

for (i in 1:nrow(m)) {
  for (j in 1:ncol(m)) {
    m[i,j] <- m[i,j] + i + j
  }
}
