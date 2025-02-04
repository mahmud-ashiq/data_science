# World Layoffs Analysis

### Project Overview
---
<p align='justify'> This project aims to provide insights into the sales performance of a bike sales dataset by analyzing key aspects of the data. Using an interactive Excel dashboard, the project explores various metrics, such as sales by gender, age group, and occupation, as well as regional sales trends. </p>

### Data Sources
<p align='justify'> The primary dataset used for this analysis is the "layoffs.csv" file.</p>

### Tools
- SQL

### Data Preprocess
- Removed duplicate values
- Removed conflitct between Matital Status 'M' and Gender 'M' by using 'Married' and 'Male'.
- Added binary class 'yes' and 'no' in 'Cars' column.
- Added age groups with specific age range.

### Processed Data
<img src= "./data.png">

### Exploratory Data Analysis
EDA involved exploring the data to answer key questions such as:
- Which education group shows the highest number of bike buyers?
- Which age group has the highest number of bike purchases, and how does this compare to other age groups?
- How does commute distance correlate with bike purchases, and which distance range shows the highest number of bike buyers?

### Results
- The graduate education level group shows the highest number of bike buyers, accounting for 31% of the total purchases.
- The middle age group is the most frequent buyers of bikes.
- Individuals with a commute distance of 0-1 miles are the largest group of bike purchasers.

# Dashboard
### Pivot Tables
<img src= "./pivot_table.png">

### Final Dashboard
<img src= "./dashboard.png">
