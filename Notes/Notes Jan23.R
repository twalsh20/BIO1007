### Entering the tidyverse
### TDW
###1/23/23


### tidy verse: collection of packages that share philospohy, grammar (or how code is strcutured), and data structures

## Operators: symbols tht tells R to perform different operations (between variables, functions, etc)

##arithmetic Operators: + - * / ^ ~
## Assignment Operators: <-
## Logical Operators: ! & |
## Relational Operators: ==, !=, >, <, <=, >=
## Misc Operators: %>% (forward pipe operator), %in%

## Only need to install packages once

library(tidyverse) # library function to load in packages

# dplyr: new(er) packages provides a set of tools for manipulating data sets
# specifically written to be fast
# individual functions that correspond to common operations


### The core verbs
## filter()
## arrange()
## select()
## group_by() and summarize()
## mutate()

## built in data set
data(starwars)
class(starwars)

## Tibble: modern take on data frames
# great aspects of data frames and drops frustrating ones(change variables)

glimpse(starwars) # much cleaner

### NAs
anyNA(starwars) # is.na # complete.cases

starwarsClean <-starwars[complete.cases(starwars[,1:10]),]
glimpse(starwarsClean)
anyNA(starwarsClean)

### filter(): picks/subsets observations(ROWS) by their values

filter(starwarsClean, gender=="masculine" & height<180) # comma means &
filter(starwarsClean, gender=="masculine" & height<180 & height>100)
# can use | for or also

#### %in% operator (matching): similar to == but can compare vectors of different lengths

#sequence of letters
a<- LETTERS[1:10]
length(a) # length of vector

b <- LETTERS[1:7]

## output of %in% depends on first vector
a %in% b
b %in% a

#use %in% to subset

eyes<-filter(starwars, eye_color %in% c("blue", "brown"))
View(eyes)

#this does same thing but more code
eyes2 <-filter(starwars, eye_color=="blue" | eye_color=="brown")
View(eyes2)

#### arrange(): reorders rows
arrange(starwarsClean, by=height) # default is ascending order
# can use helper variable desc()
arrange(starwarsClean, by=desc(height))

arrange(starwarsClean, height, desc(mass)) # second varibale used to break ties 

sw<-arrange(starwars, by=height)
tail(sw) # missing values are arranged at end

#### select(): chooses variables (COLUMNS) by their names

select(starwarsClean, 1:11)
select(starwarsClean, name:species)
select(starwarsClean, -(films:starships))
starwarsClean[,1:11]
#all do same

### Rearrange columns
select(starwarsClean, name, gender, species, everything())# everything is a helper function; useful if you have variables you want to move to beginning

# contains() helper function
select(starwarsClean, contains("color")) # others include: ends_with(), starts_with(), num_range()

# select can also rename columns
select(starwarsClean, haircolor = hair_color) # returns only renamed column; can add everything() to do same as below
rename(starwarsClean, haircolor = hair_color) # returns whole dataframe

#### mutate(): creates new variables using functions of existing variables
# let's create a new column that is height divided by mass
mutate(starwarsClean, ratio = height/mass)

starwars_lbs <- mutate(starwarsClean, mass_lbs = mass*2.2, .after=mass) #.after/.before # have to use . before argument so it recognizes it
View(starwars_lbs)
starwars_lbs<- select(starwars_lbs, 1:3, mass_lbs, everything())
glimpse(starwars_lbs) # brought it to the front using select()

# transmute
transmute(starwarsClean, mass_lbs=mass*2.2) #only returns mutated columns
transmute(starwarsClean, mass, mass_lbs=mass*2.2, height)


### group_by() and summarize(): can be used separately, but best together
summarize(starwarsClean, meanHeight= mean(height)) # throws NA if there are any NAs, use na.rm

summarize(starwarsClean, meanHeight= mean(height), TotalNumber=n())

# use group_by() for maximum usefulness
starwarsGenders<- group_by(starwars, gender)
head(starwarsGenders)

summarize(starwarsGenders, meanHeight=mean(height, na.rm=T), TotalNumber=n())

# Piping %>%
# used to emphasize a sequence of actions
# allows you to pass an intermediate results onto the next function(uses output of one function as input for next)
# avoid if you need to manipulate more than one object/variable at a time; or if variable is meaningful
# formatting: should have a space before the %>% followed by new line

starwarsClean %>%
  group_by(gender) %>%
  summarize(meanHeight=mean(height,na.rm=TRUE), TotalNumber=n()) # much cleaner with piping!

## case_when() is useful for multiple if/ifelse statements
starwarsClean %>%
  mutate(sp= case_when(species=="Human" ~ "Human", True ~ "Non-Human")) # uses condition, puts "Human" if True in sp column, puts "Non-Human" if False ??












