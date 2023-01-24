#### Vectors, Matrices, Data Frames, and Lists
#### 17 January 2023
#### TDW


#### Vectors Contd
#### Properties

## Coercion 

### All atomic vectors are of the same data type
### If you use c() to assemble different data types, R coerces them 
### Logical -> integer -> double -> character

a <- c(2, 2.2)
a #coerces to double
typeof(a)

b <- c("purple", "green")
typeof(b)

d <- c(a,b)
typeof(d)


### comparison operators yeild logical result
a <- runif(10)
print(a)

a < 0.5 # conditional statement

### How many elements in vector are greater than 0.5?

sum(a>0.5)
mean(a>0.5) # what proportion of vector greater than 0.5


#### Vectorization
## add constant to a vector

z <- c(10, 20, 30)
print(z)
z+1

## what happens when vectors are added together

y <- c(1,2,3)
z+y # results in "element by element" operation on the vector

z^2


## Recycling 
# what if vector lengths are not equal?

z
x <- c(1,2)
z+x # warning issued but calculation is still made
# shorter vector is always recycled


#### Simulating data: runif and rnorm()

runif(5)
runif(5, min=5, max=10) # n = sample size, min= minimum, max = maximum

set.seed(111) # set.seed can any number, sets random number generator (is reproducible)

runif(5, min=5, max=10)


## rnorm: random normal values with mean 0 and sd 1

rnorm(6)
randomNormalNumbers <- rnorm(100)
mean(randomNormalNumbers) # hist function shows distribution

hist(randomNormalNumbers)
sd(randomNormalNumbers)


hist(runif(n=100, min=5, max=10))

hist(rnorm(100, mean=100, sd=30))



##### Matrix
### 2 dimensional (rows and columns)
### homogeneous data type

# matrix is an atomic vector organized into rows and columns

my_vec <- 1:12

m <- matrix(data=my_vec, nrow=4)

m <- matrix(data=my_vec, ncol=3)

m <- matrix(data=my_vec, ncol=3, byrow=T)


##### Lists 
### are atomic vectors, BUT each element can hold different data types (and different sizes)

myList <- list(1:10, matrix(1:8, nrow=4, byrow=T), letters[1:3], pi)

class(myList)
str(myList)

### Sub setting lists
## using [] gives you a single item BUT not the elements

myList[4]
myList[4] -3 # single bracket gives you only elements in slot which is always type=list

# to grab object itself use [[]]
myList[[4]] # now we access contents 
myList[[4]] - 3

myList[[2]]
myList[2]
myList[[2]][4,1] # 2 dimensional sub setting, to extract specific value from matrix [row, column]

myList[c(1,2)] # to obtain multiple compartments of list
c(myList[[1]], myList[[2]]) # to obtain multiple elements within list

### Name items in list when they are created

myList2 <- list(Tester=FALSE, littleM = matrix(1:9, nrow=3))

myList2$ # dollar sign looks within list for names 
  
myList2$Tester
myList2$littleM[2,3] # extracts second row, third column of littleM

myList2$littleM[2,] # leave blank if you want all elements [2, ] = second row, all columns

myList2$littleM[8] # this gives second element

### unlist to string everything back to vectors

unRolled <- unlist(myList2)
unRolled

data(iris)
head(iris)
plot(Sepal.Length ~ Petal.Length, data=iris)
model <- lm(Sepal.Length ~ Petal.Length, data=iris)
results <- summary(model)
class(results)
typeof(results)
str(results)
results$coefficients

results$coefficients[2,4]
results[[4]][2,4]

pee <- unlist(results$coefficients)[8]
unlist(results)$coefficients8

### Data frames
## (list of) equal-lengthed vectors, each of which is a column

varA <- 1:12
varB <- rep(c("Con","LowN","HighN"), each= 4)
varC <- runif(12)

dFrame <- data.frame(varA, varB, varC, stringsAsFactors = FALSE)
str(dFrame)

# add another row


newData <- list(varA=13, varB="HighN", varC=0.668)

# use rbind()

dFrame <- rbind(dFrame, newData)

### why cant we use c()?
newData2 <- c(14, "HighN", 0.668)
dFrame <- rbind(dFrame, newData2) # vector will make all data characters

str(dFrame)

### add a column
newVar <- runif(14)

# use cbind() function to add column

dFrame <- cbind(dFrame, newVar)

# dim() checks rows and columns

dim(dFrame)


### Data Frames vs Matrices

zMat <- matrix(data=1:30, ncol=3, byrow=T)
zDframe <- as.data.frame(zMat)

str(zDframe)
str(zMat)

zMat[3,3]
zDframe[3,3]

zMat[,3]
zDframe[,3]

zDframe$V3

zMat[3,]
zDframe[3,]

zMat[3] # matrix gives third element
zDframe[3] # data frame gives third element which is full column



#### Eliminating NA's 
# complete.cases() function

zD <- c(NA, rnorm(10), NA, rnorm(3))
complete.cases(zD) # gives logical output

# clean out NA's 
zD[complete.cases(zD)]
which(!complete.cases(zD)) # also can use which(is.na(zD))


# also use with matrix

m <- matrix(1:20, nrow=5)
m[1,1] <- NA
m[5,4] <- NA

complete.cases(m) # will tell you T/F if whole row is complete(no NA's)

m[complete.cases(m),]

## get complete.cases for only certain rows

m[complete.cases(m[,c(1:2)]),] # give me all rows that have complete cases, but only look at first 2 columns but show all columns?

##### Finishing up Data Frames and Matrices
### TDW
### Jan 19 2023

m <- matrix(data=1:12, nrow=3)
m

## subsetting based on elements
m[1:2, ] # rows 1 and 2 all the columns
m[,2:4] # all rows and columns 2 to 4

## subset with logical (conditional) statements
## select all columns for which totals are > 15

colSums(m) > 15
m[,colSums(m)>15]

## row sums now
## select rows that sum to 22 exactly

rowSums(m) == 22
m[rowSums(m)==22,]

rowSums(m)!=22

### Logical operators: == != > <

## subsetting to a vector changes the data type

z <- m[1,]
print(z)
str(z)

z2 <- m[1, ,drop=FALSE]
z2

# simulate new matrix
m2 <- matrix(data= runif(9), nrow=3)
m2
m2[3,2] # use row and column to grab value not placement

### use assignment operator to substitute values
m2[m2>0.6] <- NA
m2

data<- iris
head(data)
tail(data)

data[3,2] # numbered indices still work

dataSub <- data[,c("Species", "Petal.Length")]
str(dataSub)

#### Sort a data frame by values

orderedIris <- iris[order(iris$Petal.Length),]
head(orderedIris)







Assignment 
class 1/17 

#asign 3 
Q2 
z2 <- rep(1:5, c(1,2,3,4,5)
          
          z3 <- rep(seq(from=5, to=1), c(1,2,3,4,5)
                    
                    Q3 queue[5} <- "serpent"

queue <- queue[-1]

queue <- c("domkey", queue)

queue <- queue[-5]

queue <- append(queue, "aphid", after=3)


Finish up with vectors:
