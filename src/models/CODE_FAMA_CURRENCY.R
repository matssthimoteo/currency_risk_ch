# Monthly_data analysis

library(readr)
monthly_data <- read_csv("Desktop/currency/dernier data/monthly_data.csv")
head(monthly_data)



# ________________AFX

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

# Assuming your dataset is named 'monthly_data'
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

CHF_InterestRate <- monthly_data$CHFi

n <- 12

# Calculate the one-month forward rate
monthly_data$ForwardRate_EUR <- monthly_data$EUR * (1 + monthly_data$EURi/n)^n * (1 + CHF_InterestRate/n)^(-n)
monthly_data$ForwardRate_USD <- monthly_data$USD * (1 + monthly_data$USDi/n)^n * (1 + CHF_InterestRate/n)^(-n)
monthly_data$ForwardRate_JPY <- monthly_data$JPY * (1 + monthly_data$JPYi/n)^n * (1 + CHF_InterestRate/n)^(-n)

monthly_data$ForwardRate_GBP <- monthly_data$GBP * (1 + monthly_data$GBPi/n)^n * (1 + CHF_InterestRate/n)^(-n)
monthly_data$ForwardRate_AUD <- monthly_data$AUD * (1 + monthly_data$AUDi/n)^n * (1 + CHF_InterestRate/n)^(-n)
monthly_data$ForwardRate_CAD <- monthly_data$CAD * (1 + monthly_data$CADi/n)^n * (1 + CHF_InterestRate/n)^(-n)

monthly_data$ForwardRate_NZD <- monthly_data$NZD * (1 + monthly_data$NZDi/n)^n * (1 + CHF_InterestRate/n)^(-n)
monthly_data$ForwardRate_SEK <- monthly_data$SEK * (1 + monthly_data$SEKi/n)^n * (1 + CHF_InterestRate/n)^(-n)
monthly_data$ForwardRate_NOK <- monthly_data$NOK * (1 + monthly_data$NOKi/n)^n * (1 + CHF_InterestRate/n)^(-n)




#  Final regression

Reg_EUR <- lm(monthly_data$EUR  ~ monthly_data$ForwardRate_EUR + monthly_data$VIX + monthly_data$AFX_EUR)
Reg_USD <- lm(monthly_data$USD  ~ monthly_data$ForwardRate_USD + monthly_data$VIX + monthly_data$AFX_USD)
Reg_JPY <- lm(monthly_data$JPY  ~ monthly_data$ForwardRate_JPY + monthly_data$VIX + monthly_data$AFX_JPY)

Reg_GBP <- lm(monthly_data$GBP  ~ monthly_data$ForwardRate_GBP + monthly_data$VIX + monthly_data$AFX_GBP)
Reg_AUD <- lm(monthly_data$AUD  ~ monthly_data$ForwardRate_AUD + monthly_data$VIX + monthly_data$AFX_AUD)
Reg_CAD <- lm(monthly_data$CAD  ~ monthly_data$ForwardRate_CAD + monthly_data$VIX + monthly_data$AFX_CAD)

Reg_NZD <- lm(monthly_data$NZD  ~ monthly_data$ForwardRate_NZD + monthly_data$VIX + monthly_data$AFX_NZD)
Reg_SEK <- lm(monthly_data$SEK  ~ monthly_data$ForwardRate_SEK + monthly_data$VIX + monthly_data$AFX_SEK)
Reg_NOK <- lm(monthly_data$NOK  ~ monthly_data$ForwardRate_NOK + monthly_data$VIX + monthly_data$AFX_NOK)


# Startgazer
library(stargazer)


models_list <- list(Reg_EUR, Reg_USD, Reg_JPY, Reg_GBP, Reg_AUD, Reg_CAD, Reg_NZD, Reg_SEK, Reg_NOK)

stargazer(models_list, title = "Regression Results", align = TRUE, type = "html", out = "regression_table.html")

