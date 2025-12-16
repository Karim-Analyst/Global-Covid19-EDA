# Global-Covid19-EDA

## Overview
This project performs **Exploratory Data Analysis (EDA)** on global COVID-19 data using SQL Server (T-SQL). It analyzes infection rates, deaths, and vaccination progress across countries and continents.

## Skills
- SQL data inspection and cleaning
- Aggregations (`SUM`, `MAX`) and percentages
- Window functions (`SUM() OVER(PARTITION BY ...)`) for rolling totals
- Creation of tables and views for analysis

## Analysis Highlights
- Infection vs Deaths by country
- Population impact and infection rates
- Countries with highest cases and deaths
- Continental death trends
- Rolling vaccination totals and % vaccinated
- Global summary of cases and deaths


## Repository Structure

Global-Covid19-EDA/

│

├── README.md

├── sql/

│   └── Global-Covid19-EDA.sql   <-- Main SQL script

├── data/

│   ├── CovidDeath.xlsx          <-- Raw COVID deaths data

│   └── CovidVaccination.xlsx    <-- Raw vaccination data


## Outcome
The SQL script creates **analysis-ready tables and views** for COVID-19 cases, deaths, and vaccinations, ready for visualization and reporting.
