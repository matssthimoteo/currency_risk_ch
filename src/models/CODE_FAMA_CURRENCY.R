
# Monthly_data analysis
library(dplyr)
library(readr)
library(lmtest)

monthly_data <- read_csv("data/processed/monthly_data.csv")
View(monthly_data)

# ____

#_______________________VIX
# we have to take the difference and log it

monthly_data$delta_Log_VIX <-  log(monthly_data$VIX)-lag(log(monthly_data$VIX)) 

# ________________AFX
# EURO


# c'est ça mais c'est une apporximation

monthly_data$ir_EUR <- c(0, -diff(monthly_data$EUR)/monthly_data$EUR[-nrow(monthly_data-1)])
monthly_data$ir_USD <- c(0, -diff(monthly_data$USD)/monthly_data$USD[-nrow(monthly_data-1)])
monthly_data$ir_JPY <- c(0, -diff(monthly_data$JPY)/monthly_data$JPY[-nrow(monthly_data-1)])

monthly_data$ir_GBP <- c(0, -diff(monthly_data$GBP)/monthly_data$GBP[-nrow(monthly_data-1)])
monthly_data$ir_AUD <- c(0, -diff(monthly_data$AUD)/monthly_data$AUD[-nrow(monthly_data-1)])
monthly_data$ir_CAD <- c(0, -diff(monthly_data$CAD)/monthly_data$CAD[-nrow(monthly_data-1)])

monthly_data$ir_NZD <- c(0, -diff(monthly_data$NZD)/monthly_data$NZD[-nrow(monthly_data-1)])
monthly_data$ir_SEK <- c(0, -diff(monthly_data$SEK)/monthly_data$SEK[-nrow(monthly_data-1)])
monthly_data$ir_NOK <- c(0, -diff(monthly_data$NOK)/monthly_data$NOK[-nrow(monthly_data-1)])


# la on calcule le vrai AFX à partir du ir_EUR


monthly_data$AFX_EUR <- rowMeans(monthly_data[, c("ir_USD", "ir_JPY", "ir_GBP", "ir_AUD", "ir_CAD", "ir_NZD", "ir_SEK", "ir_NOK")], na.rm = TRUE)
monthly_data$AFX_USD <- rowMeans(monthly_data[, c("ir_EUR", "ir_JPY", "ir_GBP", "ir_AUD", "ir_CAD", "ir_NZD", "ir_SEK", "ir_NOK")], na.rm = TRUE)
monthly_data$AFX_JPY <- rowMeans(monthly_data[, c("ir_USD", "ir_EUR", "ir_GBP", "ir_AUD", "ir_CAD", "ir_NZD", "ir_SEK", "ir_NOK")], na.rm = TRUE)

monthly_data$AFX_GBP <- rowMeans(monthly_data[, c("ir_USD", "ir_JPY", "ir_EUR", "ir_AUD", "ir_CAD", "ir_NZD", "ir_SEK", "ir_NOK")], na.rm = TRUE)
monthly_data$AFX_AUD <- rowMeans(monthly_data[, c("ir_USD", "ir_JPY", "ir_GBP", "ir_EUR", "ir_CAD", "ir_NZD", "ir_SEK", "ir_NOK")], na.rm = TRUE)
monthly_data$AFX_CAD <- rowMeans(monthly_data[, c("ir_USD", "ir_JPY", "ir_GBP", "ir_AUD", "ir_EUR", "ir_NZD", "ir_SEK", "ir_NOK")], na.rm = TRUE)

monthly_data$AFX_NZD <- rowMeans(monthly_data[, c("ir_USD", "ir_JPY", "ir_GBP", "ir_AUD", "ir_CAD", "ir_EUR", "ir_SEK", "ir_NOK")], na.rm = TRUE)
monthly_data$AFX_SEK <- rowMeans(monthly_data[, c("ir_USD", "ir_JPY", "ir_GBP", "ir_AUD", "ir_CAD", "ir_NZD", "ir_EUR", "ir_NOK")], na.rm = TRUE)
monthly_data$AFX_NOK <- rowMeans(monthly_data[, c("ir_USD", "ir_JPY", "ir_GBP", "ir_AUD", "ir_CAD", "ir_NZD", "ir_SEK", "ir_EUR")], na.rm = TRUE)





# ________________FORWARD DISCOUNT

SpotRate <- monthly_data$EUR
EUR_InterestRate <- monthly_data$EURi
CHF_InterestRate <- monthly_data$CHFi

# Number of compounding periods
n <- 12

# Calculate the one-month log forward rate
monthly_data$ForwardRate_EUR <- log(monthly_data$EUR * (1 + monthly_data$EURi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))
monthly_data$ForwardRate_USD <- log(monthly_data$USD * (1 + monthly_data$USDi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))
monthly_data$ForwardRate_JPY <- log(monthly_data$JPY * (1 + monthly_data$JPYi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))

monthly_data$ForwardRate_GBP <- log(monthly_data$GBP * (1 + monthly_data$GBPi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))
monthly_data$ForwardRate_AUD <- log(monthly_data$AUD * (1 + monthly_data$AUDi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))
monthly_data$ForwardRate_CAD <- log(monthly_data$CAD * (1 + monthly_data$CADi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))

monthly_data$ForwardRate_NZD <- log(monthly_data$NZD * (1 + monthly_data$NZDi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))
monthly_data$ForwardRate_SEK <- log(monthly_data$SEK * (1 + monthly_data$SEKi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))
monthly_data$ForwardRate_NOK <- log(monthly_data$NOK * (1 + monthly_data$NOKi/100)^(-1/n) * (1 + CHF_InterestRate/100)^(1/n))

# LOG spot

monthly_data$log_spot_EUR <- log(monthly_data$EUR) 
monthly_data$log_spot_USD <- log(monthly_data$USD) 
monthly_data$log_spot_JPY <- log(monthly_data$JPY) 

monthly_data$log_spot_GBP <- log(monthly_data$GBP) 
monthly_data$log_spot_AUD <- log(monthly_data$AUD) 
monthly_data$log_spot_CAD <- log(monthly_data$CAD) 

monthly_data$log_spot_NZD <- log(monthly_data$NZD) 
monthly_data$log_spot_SEK <- log(monthly_data$SEK) 
monthly_data$log_spot_NOK <- log(monthly_data$NOK) 


# DIFF

monthly_data$F_S_EUR <- monthly_data$ForwardRate_EUR - monthly_data$log_spot_EUR
monthly_data$F_S_USD <- monthly_data$ForwardRate_USD - monthly_data$log_spot_USD
monthly_data$F_S_JPY <- monthly_data$ForwardRate_JPY - monthly_data$log_spot_JPY

monthly_data$F_S_GBP <- monthly_data$ForwardRate_GBP - monthly_data$log_spot_GBP
monthly_data$F_S_AUD <- monthly_data$ForwardRate_AUD - monthly_data$log_spot_AUD 
monthly_data$F_S_CAD <- monthly_data$ForwardRate_CAD - monthly_data$log_spot_CAD

monthly_data$F_S_NZD <- monthly_data$ForwardRate_NZD - monthly_data$log_spot_NZD 
monthly_data$F_S_SEK <- monthly_data$ForwardRate_SEK - monthly_data$log_spot_SEK
monthly_data$F_S_NOK <- monthly_data$ForwardRate_NOK - monthly_data$log_spot_NOK 

# difflog  of the spot
monthly_data$Log_diff_spot_EUR <-  log(monthly_data$EUR)-lag(log(monthly_data$EUR))
monthly_data$Log_diff_spot_USD <-  log(monthly_data$USD)-lag(log(monthly_data$USD)) 
monthly_data$Log_diff_spot_JPY <-  log(monthly_data$JPY)-lag(log(monthly_data$JPY)) 

monthly_data$Log_diff_spot_GBP <-  log(monthly_data$GBP)-lag(log(monthly_data$GBP)) 
monthly_data$Log_diff_spot_AUD <-  log(monthly_data$AUD)-lag(log(monthly_data$AUD)) 
monthly_data$Log_diff_spot_CAD <-  log(monthly_data$CAD)-lag(log(monthly_data$CAD)) 

monthly_data$Log_diff_spot_NZD <-  log(monthly_data$NZD)-lag(log(monthly_data$NZD)) 
monthly_data$Log_diff_spot_SEK <-  log(monthly_data$SEK)-lag(log(monthly_data$SEK)) 
monthly_data$Log_diff_spot_NOK <-  log(monthly_data$NOK)-lag(log(monthly_data$NOK)) 



#  Final regression

Reg_EUR <- lm(monthly_data$Log_diff_spot_EUR  ~ monthly_data$F_S_EUR + monthly_data$delta_Log_VIX + monthly_data$AFX_EUR)
Reg_USD <- lm(monthly_data$Log_diff_spot_USD  ~ monthly_data$F_S_USD + monthly_data$delta_Log_VIX + monthly_data$AFX_USD)
Reg_JPY <- lm(monthly_data$Log_diff_spot_JPY  ~ monthly_data$F_S_JPY + monthly_data$delta_Log_VIX + monthly_data$AFX_JPY)

Reg_GBP <- lm(monthly_data$Log_diff_spot_GBP  ~ monthly_data$F_S_GBP + monthly_data$delta_Log_VIX + monthly_data$AFX_GBP)
Reg_AUD <- lm(monthly_data$Log_diff_spot_AUD  ~ monthly_data$F_S_AUD + monthly_data$delta_Log_VIX + monthly_data$AFX_AUD)
Reg_CAD <- lm(monthly_data$Log_diff_spot_CAD  ~ monthly_data$F_S_CAD + monthly_data$delta_Log_VIX + monthly_data$AFX_CAD)

Reg_NZD <- lm(monthly_data$Log_diff_spot_NZD  ~ monthly_data$F_S_NZD + monthly_data$delta_Log_VIX + monthly_data$AFX_NZD)
Reg_SEK <- lm(monthly_data$Log_diff_spot_SEK  ~ monthly_data$F_S_SEK + monthly_data$delta_Log_VIX + monthly_data$AFX_SEK)
Reg_NOK <- lm(monthly_data$Log_diff_spot_NOK  ~ monthly_data$F_S_NOK + monthly_data$delta_Log_VIX + monthly_data$AFX_NOK)


# Startgazer
library(stargazer)


models_list <- list(Reg_EUR, Reg_USD, Reg_JPY, Reg_GBP, Reg_AUD, Reg_CAD, Reg_NZD, Reg_SEK, Reg_NOK)


# Generate the table
stargazer(models_list, title = "Regression Results", align = TRUE, type = "html", out = "regression_table.html")




