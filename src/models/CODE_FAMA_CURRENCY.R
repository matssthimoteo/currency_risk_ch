#library(renv)
install.packages("renv")
renv::restore()
# renv::install(c("dplyr", "readr", "lmtest", "stargazer"))



# library(renv)
# activate()
# 
# renv::install("dplyr")
# renv::install("readr")
# renv::install("lmtest")
# renv::install("stargazer")


# Monthly_data analysis
library(dplyr)
library(readr)
library(lmtest)
library(stargazer)


# Monthly_data analysis
library(dplyr)
library(readr)
library(lmtest)
library(stargazer)

monthly_data <- read_csv("data/processed/monthly_data.csv")
head(monthly_data)

# ____
#_______________________VIX
# we have to take the difference and log it

monthly_data$delta_Log_VIX <-  log(monthly_data$VIX)-lag(log(monthly_data$VIX)) 

# ________________AFX



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

# assumptionS

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

# difflog  of the spot, change Log_diff_spot_XXX by XXX_
monthly_data$EUR_ <-  log(monthly_data$EUR)-lag(log(monthly_data$EUR))
monthly_data$USD_ <-  log(monthly_data$USD)-lag(log(monthly_data$USD)) 
monthly_data$JPY_ <-  log(monthly_data$JPY)-lag(log(monthly_data$JPY)) 

monthly_data$GBP_ <-  log(monthly_data$GBP)-lag(log(monthly_data$GBP)) 
monthly_data$AUD_ <-  log(monthly_data$AUD)-lag(log(monthly_data$AUD)) 
monthly_data$CAD_ <-  log(monthly_data$CAD)-lag(log(monthly_data$CAD)) 

monthly_data$NZD_ <-  log(monthly_data$NZD)-lag(log(monthly_data$NZD)) 
monthly_data$SEK_ <-  log(monthly_data$SEK)-lag(log(monthly_data$SEK)) 
monthly_data$NOK_ <-  log(monthly_data$NOK)-lag(log(monthly_data$NOK)) 



#  Final regression

Reg_EUR <- lm(monthly_data$EUR_  ~ monthly_data$F_S_EUR + monthly_data$delta_Log_VIX + monthly_data$AFX_EUR)
Reg_USD <- lm(monthly_data$USD_  ~ monthly_data$F_S_USD + monthly_data$delta_Log_VIX + monthly_data$AFX_USD)
Reg_JPY <- lm(monthly_data$JPY_  ~ monthly_data$F_S_JPY + monthly_data$delta_Log_VIX + monthly_data$AFX_JPY)

Reg_GBP <- lm(monthly_data$GBP_  ~ monthly_data$F_S_GBP + monthly_data$delta_Log_VIX + monthly_data$AFX_GBP)
Reg_AUD <- lm(monthly_data$AUD_  ~ monthly_data$F_S_AUD + monthly_data$delta_Log_VIX + monthly_data$AFX_AUD)
Reg_CAD <- lm(monthly_data$CAD_  ~ monthly_data$F_S_CAD + monthly_data$delta_Log_VIX + monthly_data$AFX_CAD)

Reg_NZD <- lm(monthly_data$NZD_  ~ monthly_data$F_S_NZD + monthly_data$delta_Log_VIX + monthly_data$AFX_NZD)
Reg_SEK <- lm(monthly_data$SEK_  ~ monthly_data$F_S_SEK + monthly_data$delta_Log_VIX + monthly_data$AFX_SEK)
Reg_NOK <- lm(monthly_data$NOK_  ~ monthly_data$F_S_NOK + monthly_data$delta_Log_VIX + monthly_data$AFX_NOK)


# Startgazer


models_list <- list(Reg_EUR, Reg_USD, Reg_JPY, Reg_GBP, Reg_AUD, Reg_CAD, Reg_NZD, Reg_SEK, Reg_NOK)


# Generate the table and put it on currency_risk_ch
stargazer(models_list, title = "Regression Results ALL", align = TRUE, type = "latex", out = "latex/tables/regression_table_ALL.tex")




#  Durbin watson test 


# Perform the Durbin-Watson test
dw_test_EUR <- dwtest(Reg_EUR)
dw_test_USD <- dwtest(Reg_USD)
dw_test_JPY <- dwtest(Reg_JPY)

dw_test_GBP <- dwtest(Reg_GBP)
dw_test_AUD <- dwtest(Reg_AUD)
dw_test_CAD <- dwtest(Reg_CAD)

dw_test_NZD <- dwtest(Reg_NZD)
dw_test_SEK <- dwtest(Reg_SEK)
dw_test_NOK <- dwtest(Reg_NOK)


# Print the test results


c 
dw_test_USD 
dw_test_JPY 

dw_test_GBP 
dw_test_AUD 
dw_test_CAD 

dw_test_NZD
dw_test_SEK 
dw_test_NOK 

# Final Table which is paper style

# Create a list of regression models
regression_models <- list(Reg_EUR, Reg_USD, Reg_JPY, Reg_GBP, Reg_AUD, Reg_CAD, Reg_NZD, Reg_SEK, Reg_NOK)

# Create a list of Durbin-Watson test results
dw_tests <- list(dw_test_EUR, dw_test_USD, dw_test_JPY, dw_test_GBP, dw_test_AUD, dw_test_CAD, dw_test_NZD, dw_test_SEK, dw_test_NOK)

# Create a data frame with the specified structure
regression_results <- data.frame(
  Currency = c("EUR", "USD", "JPY", "GBP", "AUD", "CAD", "NZD", "SEK", "NOK"),
  Constant = rep(NA, 9),
  F_S = rep(NA, 9),
  VIX = rep(NA, 9),
  AFX = rep(NA, 9),
  DW_Test = rep(NA, 9)  # Add a new column for Durbin-Watson test
)

# Fill in the data frame with coefficients and DW test from each regression
for (i in seq_along(regression_models)) {
  regression_coefs <- coef(regression_models[[i]])
  dw_statistic <- dw_tests[[i]]$statistic
  p_value <- dw_tests[[i]]$p.value
  
  regression_results[i, c("Constant", "F_S", "VIX", "AFX")] <- regression_coefs[1:4]
  regression_results[i, "DW_Test"] <- ifelse(p_value < 0.01, paste0(round(dw_statistic, 2), "***"),
                                             ifelse(p_value < 0.05, paste0(round(dw_statistic, 2), "**"),
                                                    ifelse(p_value < 0.1, paste0(round(dw_statistic, 2), "*"),
                                                           paste0(round(dw_statistic, 2)))))
}

# Print the resulting data frame
print(regression_results)

# this function doesnt work
# sink("Table_currency_and_DW.tex")



#  doing a table three at the time for the final presentation

models_list1 <- list(Reg_EUR, Reg_USD, Reg_JPY)
stargazer(models_list1, align = TRUE, type = "latex", out = "latex/tables/regression_table_EUR_USD_JPY.tex")


models_list2 <- list(Reg_GBP, Reg_AUD, Reg_CAD)
stargazer(models_list2, align = TRUE, type = "latex", out = "latex/tables/regression_table_GBP_AUD_CAD.tex")

models_list3 <- list(Reg_NZD, Reg_SEK, Reg_NOK)
stargazer(models_list3, align = TRUE, type = "latex", out = "latex/tables/regression_table_NZD_SEK_NOK.tex")


# title = "Regression Results "


#  Robust regression

monthly_data$spread <- monthly_data$IT_minus_DE

Reg_EUR_R <- lm(monthly_data$EUR_  ~ monthly_data$F_S_EUR + monthly_data$delta_Log_VIX + monthly_data$AFX_EUR + monthly_data$spread)
Reg_USD_R <- lm(monthly_data$USD_  ~ monthly_data$F_S_USD + monthly_data$delta_Log_VIX + monthly_data$AFX_USD + monthly_data$spread)
Reg_JPY_R <- lm(monthly_data$JPY_  ~ monthly_data$F_S_JPY + monthly_data$delta_Log_VIX + monthly_data$AFX_JPY + monthly_data$spread)

Reg_GBP_R <- lm(monthly_data$GBP_  ~ monthly_data$F_S_GBP + monthly_data$delta_Log_VIX + monthly_data$AFX_GBP + monthly_data$spread)
Reg_AUD_R <- lm(monthly_data$AUD_  ~ monthly_data$F_S_AUD + monthly_data$delta_Log_VIX + monthly_data$AFX_AUD + monthly_data$spread)
Reg_CAD_R <- lm(monthly_data$CAD_  ~ monthly_data$F_S_CAD + monthly_data$delta_Log_VIX + monthly_data$AFX_CAD + monthly_data$spread)

Reg_NZD_R <- lm(monthly_data$NZD_  ~ monthly_data$F_S_NZD + monthly_data$delta_Log_VIX + monthly_data$AFX_NZD + monthly_data$spread)
Reg_SEK_R <- lm(monthly_data$SEK_  ~ monthly_data$F_S_SEK + monthly_data$delta_Log_VIX + monthly_data$AFX_SEK + monthly_data$spread)
Reg_NOK_R <- lm(monthly_data$NOK_  ~ monthly_data$F_S_NOK + monthly_data$delta_Log_VIX + monthly_data$AFX_NOK + monthly_data$spread)

Reg_EUR_RTED <- lm(monthly_data$EUR_  ~ monthly_data$F_S_EUR + monthly_data$delta_Log_VIX + monthly_data$AFX_EUR + monthly_data$TED_spread)
Reg_USD_RTED <- lm(monthly_data$USD_  ~ monthly_data$F_S_USD + monthly_data$delta_Log_VIX + monthly_data$AFX_USD + monthly_data$TED_spread)
Reg_JPY_RTED <- lm(monthly_data$JPY_  ~ monthly_data$F_S_JPY + monthly_data$delta_Log_VIX + monthly_data$AFX_JPY + monthly_data$TED_spread)

Reg_GBP_RTED <- lm(monthly_data$GBP_  ~ monthly_data$F_S_GBP + monthly_data$delta_Log_VIX + monthly_data$AFX_GBP + monthly_data$TED_spread)
Reg_AUD_RTED <- lm(monthly_data$AUD_  ~ monthly_data$F_S_AUD + monthly_data$delta_Log_VIX + monthly_data$AFX_AUD + monthly_data$TED_spread)
Reg_CAD_RTED <- lm(monthly_data$CAD_  ~ monthly_data$F_S_CAD + monthly_data$delta_Log_VIX + monthly_data$AFX_CAD + monthly_data$TED_spread)

Reg_NZD_RTED <- lm(monthly_data$NZD_  ~ monthly_data$F_S_NZD + monthly_data$delta_Log_VIX + monthly_data$AFX_NZD + monthly_data$TED_spread)
Reg_SEK_RTED <- lm(monthly_data$SEK_  ~ monthly_data$F_S_SEK + monthly_data$delta_Log_VIX + monthly_data$AFX_SEK + monthly_data$TED_spread)
Reg_NOK_RTED <- lm(monthly_data$NOK_  ~ monthly_data$F_S_NOK + monthly_data$delta_Log_VIX + monthly_data$AFX_NOK + monthly_data$TED_spread)

#  List Robust regression DE IT SPREAD

models_list_Robust1 <- list(Reg_EUR_R, Reg_USD_R, Reg_JPY_R)
stargazer(models_list_Robust1, align = TRUE, type = "latex", out = "latex/tables/regression_table_EUR_USD_JPY_R.tex")

models_list_Robust2 <- list( Reg_GBP_R, Reg_AUD_R, Reg_CAD_R)
stargazer(models_list_Robust2, align = TRUE, type = "latex", out = "latex/tables/regression_table_GBP_AUD_CAD_R.tex")

models_list_Robust3 <- list( Reg_NZD_R, Reg_SEK_R, Reg_NOK_R)
stargazer(models_list_Robust3, align = TRUE, type = "latex", out = "latex/tables/regression_table_NZD_SEK_NOK_R.tex")


# List TED spread 

models_list_RobustTED1 <- list(Reg_EUR_RTED, Reg_USD_RTED, Reg_JPY_RTED)
stargazer(models_list_RobustTED1, align = TRUE, type = "latex", out = "latex/tables/regression_table_EUR_USD_JPY_RTED.tex")

models_list_RobustTED2 <- list( Reg_GBP_RTED, Reg_AUD_RTED, Reg_CAD_RTED)
stargazer(models_list_RobustTED2, align = TRUE, type = "latex", out = "latex/tables/regression_table_GBP_AUD_CAD_RTED.tex")

models_list_RobustTED3 <- list( Reg_NZD_RTED, Reg_SEK_RTED, Reg_NOK_RTED)
stargazer(models_list_RobustTED3, align = TRUE, type = "latex", out = "latex/tables/regression_table_NZD_SEK_NOK_RTED.tex")





