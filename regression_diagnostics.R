library(readxl)
library(ggplot2)
library(lme4)
library(lmerTest) 
library(foreign)
library(plyr)
library(dplyr)
library(MuMIn)
library (ggpubr)
library (car)

df <- read.csv ("E:/CBD_python/hedgesg_genes.csv", fileEncoding = 'UTF-8-BOM')
head(df)

######

#Model
summary(fit <- lm(mymean_est~ FAAH+DRD2+HTR1A+CNR1, data=df)) 
confint(fit,method="Wald")
r.squaredGLMM(fit) 

######

# Assessing Outliers
outlierTest(fit) # Bonferonni p-value for most extreme obs
qqPlot(fit, main="QQ Plot") #qq plot for studentized resid
leveragePlots(fit) # leverage plots

# Influential Observations
# added variable plots
#av.Plots(fit) This line doesn't run but not important as I have my own cooks D below
# Cook's D plot
# identify D values > 4/(n-k-1)
cutoff <- 4/((nrow(df)-length(fit$coefficients)-2))
plot(fit, which=4, cook.levels=cutoff)
# Influence Plot
influencePlot(fit, id.method="identify", main="Influence Plot", sub="Circle size is proportial to Cook's Distance" )


#######
cooksdf <- cooks.distance(fit)

sample_size <- nrow(df)
plot(cooksdf, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 4/sample_size, col="red")  # add cutoff line
text(x=1:length(cooksdf)+1, y=cooksdf, labels=ifelse(cooksdf>4/sample_size, names(cooksdf),""), col="red")  # add labels

######


# Normality of Residuals
# qq plot for studentized resid
qqPlot(fit, main="QQ Plot")
# distribution of studentized residuals
library(MASS)
sresid <- studres(fit)
hist(sresid, freq=FALSE,
     main="Distribution of Studentized Residuals")
xfit<-seq(min(sresid),max(sresid),length=40)
yfit<-dnorm(xfit)
lines(xfit, yfit)

######

# Evaluate homoscedasticity
# non-constant error variance test
ncvTest(fit)
# plot studentized residuals vs. fitted values
spreadLevelPlot(fit)


# Evaluate Collinearity
vif(fit) # variance inflation factors
sqrt(vif(fit)) > 2 # problem?


# Evaluate Nonlinearity
# component + residual plot
crPlots(fit)
# Ceres plots
ceresPlots(fit)


# Test for Autocorrelated Errors
durbinWatsonTest(fit)


#For psychosis
summary(fit <- lm(psychosis_est~ FAAH+DRD2+HTR1A+CNR1, data=df)) 
confint(fit,method="Wald")
r.squaredGLMM(fit) 





