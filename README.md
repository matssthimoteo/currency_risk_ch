# Currency risks for Swiss residents

## Table of contents
1. [Introduction](#introduction)
     1. [Motivation](#motivation)
     2. [Research question](#question)
2. [Requirements](#requirements)
    1. [Virtual environments](#environments)
    2. [Tbd](#tbd)
3. [Results](#results)
______________________________________


## Introduction
The Covid crisis in 2019 confirmed once more the safe haven currency status of the CHF. While a safe
haven currency status might be beneficial from a value storage perspective, it certainly presents
challenges regarding other perspectives. How are residents of safe haven currency countries affected by their currency? The aim of this project is to determine the riskiest currency to hold for a Swiss residents. 

### Motivation
![Returns in different currencies](latex/figures/ccy_perfs.jpg "Returns in different currencies")

### Research question

> **Which of the G10 currencies is the riskiest to
hold for a Swiss resident?**
_____________________________________
## Requirements

### Virtual environments
This project's code is partially in R and partially in Python. It's necessary to have an R version >=3.0.0, which can be installed (in Windows) with:
```batch
@echo off

REM Set the path where R will be installed
set R_INSTALL_PATH=C:\Program Files\R\R-4.1.2

REM Download the R installer
curl -O https://cran.r-project.org/bin/windows/base/R-4.1.2-win.exe

REM Install R silently
start /wait R-4.1.2-win.exe /S /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /DIR=%R_INSTALL_PATH%

REM Add R to the system PATH
setx PATH "%PATH%;%R_INSTALL_PATH%\bin\x64" /M

REM Clean up
del R-4.1.2-win.exe
```

The execution of the R script in this project installs already the required dependencies.

For the python environment, the setup is made through running a setup file. It supposes that the computer has conda installed and will install the dependencies described on "requirements.txt".

Windows:
```batch
setup.bat
```

Linux / MacOS:
```bash
setup.sh
```

______________________________________
## Results
Results are shown in [walkthrough](walkthrough.ipynb).
______________________________________