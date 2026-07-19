# ADS-AI Course Dashboard (FSBS)

![R](https://img.shields.io/badge/R-Shiny-276DC3?style=flat&logo=r&logoColor=white)
![License](https://img.shields.io/badge/License-GPL--3.0-green?style=flat)

Interactive **R Shiny** dashboard for exploring the data science and AI courses offered within the **Faculty of Social and Behavioural Sciences (FSBS)** at Utrecht University.

🔗 **Live app: [tshahedi.shinyapps.io/ads-ai-taskforce](https://tshahedi.shinyapps.io/ads-ai-taskforce/)**

## Features

- **Course explorer** — browse detailed information on ADS-AI courses within FSBS
- **Keyword search** — find courses by covered topics
- **Interactive visualizations** — D3 bubble charts (`r2d3`), plotly charts, and searchable tables

## Data

| File | Contents |
|---|---|
| `DS courses FSBS.xlsx` | Detailed records of ADS-AI courses within FSBS |
| `short.xlsx` | Keywords and topics covered per course |

## Run locally

```r
install.packages(c(
  "shiny", "shinydashboard", "shinythemes", "shinyWidgets",
  "tidyverse", "plotly", "DT", "readxl", "RColorBrewer",
  "ggthemes", "packcircles", "r2d3", "htmlwidgets", "here"
))
shiny::runApp()
```

## Repository structure

```text
.
├── ui.R                    # dashboard layout
├── server.R                # server logic and plots
├── bubble.js / bubble_2.js # D3 bubble chart code used via r2d3
├── ShinyApp.Rmd            # development notebook
├── DS courses FSBS.xlsx    # course data
└── short.xlsx              # course keywords
```

## Acknowledgments

Adapted from the [UU-DS-courses](https://github.com/a-dacko/UU-DS-courses) project, customized for FSBS with updated datasets and visualizations.

## License

Released under the [GPL-3.0 License](LICENSE).
