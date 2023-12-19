# Currency risks for Swiss residents

## Table of contents
1. [Introduction](#introduction)
     1. [Motivation](#motivation)
     2. [Research question](#question)
2. [Requirements](#requirements)
    1. [Virtual environments](#environments)
        1. [R](#r)
        2. [Python](#python)
3. [Results](#results)
______________________________________


## Introduction
The Covid crisis in 2019 confirmed once more the safe haven currency status of the CHF. While a safe
haven currency status might be beneficial from a value storage perspective, it certainly presents
challenges regarding other perspectives. How are residents of safe haven currency countries affected by their currency? The aim of this project is to determine the riskiest currency to hold for a Swiss residents. 
_____________________________________
### Motivation
![Returns in different currencies](latex/figures/ccy_perfs.jpg "Returns in different currencies")
_____________________________________
### Research question

> **Which of the G10 currencies is the riskiest to
hold for a Swiss resident?**
_____________________________________
## Requirements

### Virtual environments
This project consists of R and Python code.
_____________________________________
#### R
The R code requires atleast **version 3.0.0** to be installed.

The R code installs itself all the required libraries.

Installation of R on Windows:
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
_____________________________________
#### Python
The Python environment will be set up through one of the setup files.

On Windows with [setup.bat](setup.bat) and on Linux / MacOS with [setup.sh](setup.sh).

Windows:
```batch
setup.bat
```

Linux / MacOS:
```bash
setup.sh
```

If conda is already installed, all the required libraries stated in [requirements](requirements.txt) will be installed automatically.
______________________________________
## Results
Results are shown in [walkthrough](walkthrough.ipynb).
______________________________________