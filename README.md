# README

## Shiny App for ADS-AI Courses

This Shiny app provides an interactive interface for exploring information about ADS-AI courses within the Faculty of Social and Behavioral Science. The app utilizes two main data files:

1. **DS courses FSBS.xlsx**: Contains detailed information about the ADS-AI courses within FSBS at UU.
2. **short.xlsx**: Contains keywords and covered topics for the courses.

Additionally, you can explore a live version of the dashboard at [ADS-AI Taskforce Dashboard](https://tshahedi.shinyapps.io/ads-ai-taskforce/). This dashboard is an interactive tool for exploring the Faculty of Social and Behavioral Science's data science courses at utrecht university.

### Background
This app was created by customizing the code from the [UU-DS-courses](https://github.com/a-dacko/UU-DS-courses) project. The modifications focus on providing a more specialized view of ADS-AI courses offered within FSBS by using real-time datasets to meet the specific needs of FSBS.

### Installation

To run this Shiny app locally, ensure you have R and the necessary packages installed.

### Usage

1. **Clone or download this repository** to your local machine.

2. **Place the data files (`DS courses FSBS.xlsx` and `short.xlsx`) in the same directory** as the Shiny app script (`ui.R` and `server.R`).

3. **Run the Shiny app** by opening R and executing the following commands:

```R
runApp("path_to_your_app_directory")
```

### App Features

- **Course Information**: Browse through relevant information about each ADS-AI course.
- **Keyword Search**: Use the keywords from `short.xlsx` to find courses covering specific topics.
