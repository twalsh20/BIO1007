#### Notes on Functions
### Jan 19 2023
### TDW

# everything in R is a function
sum(3,2) #sum
3+2 # + sign is a function
sd

### User defined functions

#functionName <- function(argX=defaultX, argY=defaultY){
  ## curly bracket starts body of function
  ### Lines of R code ### and notes
  ### create local variables (only 'visible' to R within the function)
  ### return(z) 
#argX <- c("IDK")
#}

myFunc <- function(a=3, b=4){
 z <- a+b 
 return(z)
}
myFunc() # runs default

myFunc(a=100, b=3.4)


b <- 50
myFuncBad <- function(a=3){
  z <- a+b 
  return(z)
}
myFuncBad() # error b not found unless there is a global variable like b <-50

myFuncDefault <- function(a=NULL, b=NULL){
  z <- a+b 
  return(z)
}
myFuncDefault() # runs default which is 0 because of NULL

print(z) # z is only found in function, throws error

z<- myFunc() #now z is recognized
z
 
### Multiple return statements

########################################################################
# FUNCTION: HardyWeinberg
# input: all allele frequency p (0,1)
# output: p and the frequencies of 3 genotype AA AB BB
#----------------------------------------------------------------------
HardyWeinberg <- function(p=runif(1)){
  if(p>1.0 | p<0.0){
    return("Function failure: p must be between 0 and 1")
  }
  q <- 1-p
  fAA <- p^2
  fAB <- 2*p*q
  fBB <-q^2
  vecOut <- signif(c(p=p, AA=fAA, AB=fAB, BB=fBB), digits = 3)
  return(vecOut)
}
##########################################################################

HardyWeinberg()
freqs <- HardyWeinberg()
freqs
HardyWeinberg(p=3.0)



### Create a complex default value
######################################################################
# Function: fitLinear2
# fits simple linear regression line
# input: list (p) of predictor (x) and response (y)
# output: slope and p-value
#-------------------------------------------------------------------
fitLinear2 <- function(p=NULL){
  if(is.null(p)){
    p<-list(x=runif(20), y=runif(20))
  }
  myMod<-lm(p$x~p$y)
  myOut<- c(slope=summary(myMod)$coefficient[2,1],
            pValue = summary(myMod)$coefficient[2,4])
  plot(x=p$x, y=p$y) #quick plot to check ouput
  return(myOut)
}

fitLinear2() # simulates p for us when p=NULL
myPars <- list(x=1:10, y=runif(10))

fitLinear2(p=myPars) 
