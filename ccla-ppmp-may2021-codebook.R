## ---------------------------
##
## Script name: ccla-ppmp-enforcement-report-may2021
##
## Purpose of script: COVID-19 and Law Enforcement in Canada: The Second Wave
##
## Author: Alex Luscombe
##
## Date Created: 2021-05-04
##
## Copyright (c) Alex Luscombe, 2021
## Email: alex.luscombe [at] mail.utoronto.ca
##
## ---------------------------
##
## Notes: access the full report here: https://ccla.org/ccla-and-ppmp-release-new-report/
##   
##
## ---------------------------

  
# load libraries
library(tidyverse)
library(scales)
library(lubridate)
library(fishualize)
library(here)

# read in enforcement data
master_df <- read_csv("covid_enforcement_data_march2021")

# Toronto, Ontario
toronto_data <- master_df %>%
  filter(city == "toronto") %>%
  filter(!is.na(charges)) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  select(date_formatted, charges, legislation, violation, violation_recoded)

toronto_data %>%
  group_by(date_formatted, violation_recoded) %>%
  summarize(charges = sum(charges)) %>%
  ggplot(aes(x = as.Date(date_formatted), y = as.numeric(charges), fill = violation_recoded)) +
  geom_col() +
  theme_minimal() +
  scale_x_date(breaks = seq(as.Date("2020-04-01"), as.Date("2021-03-01"), by = "1 month"), date_labels = "%b %Y") +
  scale_fill_fish_d(option = "Hypsypops_rubicundus", direction = -1) +
  scale_y_continuous(breaks = seq(0, 600, by = 100)) +
  theme(axis.text.x = element_text(angle = 0)) +
  theme(legend.position = "top") +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  theme(plot.title = element_text(face = "bold")) +
  labs(x = "", 
       y = "",
       fill = "",
       title = "COVID-19 Related Fines in Toronto, Ontario",
       subtitle = "April, 2020 - March, 2021. Y-axis indicates number of fines. Shading indicates wave 2.",
       caption = "Data source: City of Toronto") +
  annotate("rect", xmin = as.Date("2020-08-16"), xmax = as.Date("2021-03-17"), ymin = 0, ymax = Inf, alpha = .2)

toronto_data %>%
  select(date_formatted, charges, violation_recoded) %>%
  group_by(date_formatted, violation_recoded) %>%
  summarize(total_charges = sum(charges)) %>%
  ungroup() %>%
  mutate(total = sum(total_charges)) %>%
  mutate(percent_total = total_charges/total*100) %>%
  group_by(date_formatted) %>%
  mutate(monthly_total = sum(total_charges)) %>%
  mutate(monthly_percent_total = total_charges/monthly_total*100)

toronto_data %>%
  select(date_formatted, charges) %>%
  group_by(date_formatted) %>%
  summarize(total_charges = sum(charges)) %>%
  ungroup() %>%
  mutate(total = sum(total_charges)) %>%
  mutate(percent_total = total_charges/total*100) %>%
  group_by(date_formatted) %>%
  mutate(monthly_total = sum(total_charges)) %>%
  mutate(monthly_percent_total = total_charges/monthly_total*100)

toronto_data %>%
  select(date_formatted, charges) %>%
  filter(date_formatted == as.Date("2020-10-01") |
           date_formatted == as.Date("2020-11-01") | 
           date_formatted == as.Date("2020-12-01") | 
           date_formatted == as.Date("2021-01-01") |
           date_formatted == as.Date("2021-02-01")) %>%
  summarize(charges = sum(as.numeric(charges))) %>%
  mutate(wave2_rate_per_1000 = as.numeric(charges)/2731571*1000) #rate per 1000 using 2016 census data


# Ottawa, Ontario
ottawa_data <- master_df %>%
  filter(city == "ottawa") %>%
  filter(!is.na(charges)) %>%
  filter(charges > 0) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  select(date_formatted, charges) %>%
  mutate(clr = "colour")

ottawa_data %>%
  ggplot(aes(x = as.Date(date_formatted), y = as.numeric(charges), fill = clr)) + 
  geom_col() +
  theme_minimal() +
  scale_x_date(breaks = seq(as.Date("2020-04-01"), as.Date("2021-03-01"), by = "1 month"), date_labels = "%b %Y") +
  scale_fill_fish_d(option = "Hypsypops_rubicundus", direction = -1) +
  theme(axis.text.x = element_text(angle = 0)) +
  theme(legend.position = "") +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  theme(plot.title = element_text(face = "bold")) +
  labs(x = "", 
       y = "",
       fill = "",
       title = "COVID-19 Related Fines in Ottawa, Ontario",
       subtitle = "April, 2020 - March, 2021. Y-axis indicates number of fines. Shading indicates wave 2.",
       caption = "Data source: City of Ottawa") +
  annotate("rect", xmin = as.Date("2020-08-16"), xmax = as.Date("2021-03-17"), ymin = 0, ymax = Inf, alpha = .2)

ottawa_data %>%
  select(date_formatted, charges) %>%
  group_by(date_formatted) %>%
  summarize(total_charges = sum(charges)) %>%
  ungroup() %>%
  mutate(total = sum(total_charges)) %>%
  mutate(percent_total = total_charges/total*100)

ottawa_data %>%
  select(date_formatted, charges) %>%
  filter(date_formatted == as.Date("2020-10-01") |
           date_formatted == as.Date("2020-11-01") | 
           date_formatted == as.Date("2020-12-01") | 
           date_formatted == as.Date("2021-01-01") |
           date_formatted == as.Date("2021-02-01")) %>%
  summarize(charges = sum(as.numeric(charges))) %>%
  mutate(wave2_rate_per_1000 = as.numeric(charges)/934243*1000) #rate per 1000 using 2016 census data

# Edmonton, Alberta
edmonton_data <- master_df %>%
  filter(city == "edmonton") %>%
  filter(!is.na(charges)) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  select(date_formatted, charges, violation)

edmonton_data %>%
  filter(date_formatted > "2020-11-01") %>%
  ggplot(aes(x = as.Date(date_formatted), y = as.numeric(charges), fill = forcats::fct_rev(violation))) + 
  geom_col() +
  theme_minimal() +
  scale_x_date(date_breaks = "month", date_labels = "%b %Y") +
  scale_fill_fish_d(option = "Hypsypops_rubicundus", direction = 1) +
  theme(axis.text.x = element_text(angle = 0)) +
  theme(legend.position = "top") +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  theme(plot.title = element_text(face = "bold")) +
  labs(x = "", 
       y = "",
       fill = "",
       title = "COVID-19 Related Fines in Edmonton, Alberta",
       subtitle = "December, 2020 - February, 2021. Y-axis indicates number of fines. Shading indicates wave 2.",
       caption = "Data source: City of Edmonton") +
  annotate("rect", xmin = as.Date("2020-11-16"), xmax = as.Date("2021-02-18"), ymin = 0, ymax = Inf, alpha = .2)

edmonton_data %>%
  filter(date_formatted > "2020-11-01") %>%
  select(date_formatted, charges, violation) %>%
  group_by(date_formatted, violation) %>%
  summarize(total_charges = sum(charges)) %>%
  mutate(monthly_total = sum(total_charges)) %>%
  ungroup() %>%
  mutate(total = sum(total_charges)) %>%
  group_by(date_formatted) %>%
  mutate(percent_total = total_charges/total*100)

# Québec
quebec_data <- master_df %>%
  filter(province == "quebec") %>%
  filter(charges != 3756) %>% #removes aggregated April to September
  filter(!is.na(charges)) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  select(date_formatted, charges) %>%
  mutate(clr = "colour")

quebec_data %>%
  ggplot(aes(x = as.Date(date_formatted), y = as.numeric(charges), fill = clr)) + 
  geom_col() +
  theme_minimal() +
  scale_x_date(date_labels = "%b %Y") +
  scale_fill_fish_d(option = "Hypsypops_rubicundus", direction = -1) +
  scale_y_continuous(breaks = seq(0, 3500, by = 500), limits = c(0, 3500)) +
  theme(legend.position = "") +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  theme(plot.title = element_text(face = "bold")) +
  labs(x = "", 
       y = "",
       fill = "",
       title = "COVID-19 Related Fines in Québec",
       subtitle = "October, 2020 - March, 2021. Y-axis indicates number of fines. Shading indicates wave 2.",
       caption = "Data source: Justice Québec") +
  annotate("rect", xmin = as.Date("2020-09-16"), xmax = as.Date("2021-03-18"), ymin = 0, ymax = Inf, alpha = .2)

quebec_data2 <- master_df %>%
  filter(province == "quebec") %>%
  filter(!is.na(charges)) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  select(date_formatted, charges, cost_total) %>%
  mutate(date_formatted = case_when(
    date_formatted == as.Date("2020-09-01") ~ "2020-04-01 to 2020-09-01",
    TRUE ~ as.character(date_formatted)
  )) %>%
  group_by(date_formatted, cost_total) %>%
  summarize(total_charges = sum(as.numeric(charges))) %>%
  print()

quebec_data %>%
  select(date_formatted, charges) %>%
  filter(date_formatted == as.Date("2020-10-01") |
           date_formatted == as.Date("2020-11-01") | 
           date_formatted == as.Date("2020-12-01") | 
           date_formatted == as.Date("2021-01-01") |
           date_formatted == as.Date("2021-02-01")) %>%
  summarize(charges = sum(as.numeric(charges))) %>%
  mutate(wave2_rate_per_1000 = as.numeric(charges)/8164361*1000) #rate per 1000 using 2016 census data

master_df %>%
  filter(province == "quebec") %>%
  filter(!is.na(charges)) %>%
  mutate(date_formatted = case_when(
    date_formatted == "September, 2020" ~ "2020-04-01 to 2020-09-01",
    TRUE ~ as.character(date_formatted)
  )) %>%
  #filter(date_formatted != "September, 2020") %>%
  select(date_formatted, individual_cost, cost_total)

# Nova Scotia
novascotia_data <- master_df %>%
  filter(province == "nova scotia") %>%
  filter(!is.na(charges)) %>%
  filter(charges > 0) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  select(date_formatted, charges, legislation, violation)

novascotia_data %>%
  mutate(legislation = case_when(
    legislation == "EMA 23(a)" ~ "EMA 23a\n($582.50)",
    legislation == "EMA 23(b)" ~ "EMA 23b\n($697.50)",
    legislation == "HPA 71(a)" ~ "HPA 71a\n($7500.00)",
    legislation == "HPA 71(b)" ~ "HPA 71b\n($1000.00)")) %>%
  ggplot(aes(x = as.Date(date_formatted), y = as.numeric(charges), fill = legislation)) + 
  geom_col() +
  theme_minimal() +
  scale_x_date(breaks = seq(as.Date("2020-03-01"), as.Date("2021-02-01"), by = "1 month"), date_labels = "%b %Y") +
  scale_y_continuous(breaks = seq(0, 450, by = 50)) +
  scale_fill_fish_d(option = "Hypsypops_rubicundus", direction = 1) +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(legend.position = "top") +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  theme(plot.title = element_text(face = "bold")) +
  labs(x = "", 
       y = "",
       fill = "",
       title = "COVID-19 Related Fines in Nova Scotia",
       subtitle = "March, 2020 - February, 2021. Y-axis indicates number of fines. Shading indicates wave 2.",
       caption = "Data source: Government of Nova Scotia") +
  annotate("rect", xmin = as.Date("2020-08-16"), xmax = as.Date("2021-02-18"), ymin = 0, ymax = Inf, alpha = .2)

novascotia_data %>%
  select(date_formatted, charges, legislation) %>%
  mutate(legislation = case_when(
    legislation == "EMA 23(a)" ~ "EMA 23a\n($582.50)",
    legislation == "EMA 23(b)" ~ "EMA 23b\n($697.50)",
    legislation == "HPA 71(a)" ~ "HPA 71a\n($7500.00)",
    legislation == "HPA 71(b)" ~ "HPA 71b\n($1000.00)")) %>%
  group_by(date_formatted, legislation) %>%
  summarize(total_charges = sum(charges)) %>%
  ungroup() %>%
  group_by(date_formatted) %>%
  mutate(monthly_total = sum(total_charges)) %>%
  mutate(monthly_percent_total = total_charges/monthly_total*100) %>%
  ungroup() %>%
  mutate(total = sum(total_charges)) %>%
  group_by(date_formatted) %>%
  mutate(percent_total = monthly_total/total*100)

novascotia_data %>%
  select(date_formatted, charges) %>%
  filter(date_formatted == as.Date("2020-10-01") |
           date_formatted == as.Date("2020-11-01") | 
           date_formatted == as.Date("2020-12-01") | 
           date_formatted == as.Date("2021-01-01") |
           date_formatted == as.Date("2021-02-01")) %>%
  summarize(charges = sum(as.numeric(charges))) %>%
  mutate(wave2_rate_per_1000 = as.numeric(charges)/923598*1000) #rate per 1000 using 2016 census data

master_df %>%
  filter(province == "nova scotia") %>%
  filter(!is.na(charges)) %>%
  filter(charges > 0) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  filter(date_formatted < "2020-09-01") %>%
  group_by(legislation) %>%
  summarize(total = sum(charges),
            amount = max(individual_cost)) %>%
  mutate(total_amount = total*amount) %>%
  ungroup() %>%
  mutate(total_total = sum(total_amount))

master_df %>%
  filter(province == "nova scotia") %>%
  filter(!is.na(charges)) %>%
  filter(charges > 0) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  filter(date_formatted >= "2020-09-01") %>%
  group_by(legislation) %>%
  summarize(total = sum(charges),
            amount = max(individual_cost)) %>%
  mutate(total_amount = total*amount) %>%
  ungroup() %>%
  mutate(total_total = sum(total_amount))

# Manitoba
manitoba_data <- master_df %>%
  filter(old_new == "new") %>%
  filter(city == "manitoba") %>%
  filter(!is.na(charges)) %>%
  #mutate(date_formatted = parse_date_time(date_formatted, c("mdy"))) %>%
  select(date_formatted, date_raw, charges, violation, ranking)

manitoba_data %>%
  mutate(violation = case_when(
    violation == "band bylaw" ~ "band bylaw\n($448)",
    violation == "business violation" ~ "business violation\n($5,000)",
    violation == "failure to wear mask" ~ "failure to wear mask\n($298)",
    violation == "various offences" ~ "various offences\n($1,296)",
    TRUE ~ as.character(violation)
  ))%>%
  mutate(date_formatted = fct_reorder(date_formatted, ranking)) %>%
  ggplot(aes(x = date_formatted, y = charges, fill = violation)) +
  geom_col() +
  theme_minimal() +
  scale_fill_fish_d(option = "Hypsypops_rubicundus", direction = 1) +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(legend.position = "top") +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  theme(plot.title = element_text(face = "bold")) +
  labs(x = "", 
       y = "",
       fill = "",
       title = "COVID-19 Related Fines in Manitoba",
       subtitle = "May, 2020 - February, 2021. Y-axis indicates number of fines. Shading indicates wave 2.",
       caption = "Data source: Government of Manitoba") +
  annotate("rect", xmin = "Aug 31-Sept 7, 2020", xmax = Inf, ymin = 0, ymax = Inf, alpha = .2)

manitoba_data %>%
  select(date_raw, charges, violation) %>%
  group_by(date_raw) %>%
  summarize(total_charges = sum(as.numeric(charges))) %>%
  ungroup() %>%
  mutate(total = sum(total_charges)) %>%
  mutate(weekly_percent_total = total_charges/total*100)

master_df %>%
  filter(province == "manitoba") %>%
  filter(!is.na(charges)) %>%
  filter(charges > 0) %>%
  filter(old_new == "new") %>%
  filter(!is.na(individual_cost)) %>%
  select(date_formatted, charges, individual_cost, violation) %>%
  group_by(violation) %>%
  summarize(total = sum(charges),
            amount = max(individual_cost)) %>%
  mutate(total_amount = total*amount) %>%
  ungroup() %>%
  mutate(total_total = sum(total_amount))

manitoba_data %>%
  select(date_raw, charges) %>%
  filter(date_raw == "September 28-October 4, 2020" |
           date_raw == "October 5-12, 2020" |
           date_raw == "October 13-18, 2020" |
           date_raw == "October 19-25, 2020" |
           date_raw == "October 26-November 1, 2020" |
           date_raw == "November 16-22, 2020" |
           date_raw == "November 2-8, 2020" |
           date_raw == "November 9-15, 2020" |
           date_raw == "November 23-29, 2020" |
           date_raw == "November 30-December 6, 2020" |
           date_raw == "December 14-20, 2020" |
           date_raw == "December 21-27, 2020" |
           date_raw == "December 28, 2020-January 3, 2021" |
           date_raw == "December 7-13, 2020" |
           date_raw == "January 11-17, 2021" |
           date_raw == "January 18-24, 2021" |
           date_raw == "January 4-10, 2021" |
           date_raw == "January 11-17, 2021" |
           date_raw == "January 18-24, 2021" |
           date_raw == "January 25-31, 2021" |
           date_raw == "February 1-7, 2021" |
           date_raw == "February 8-14, 2021" |
           date_raw == "February 15-21, 2021" |
           date_raw == "February 22-28, 2021"
  ) %>%
  summarize(charges = sum(as.numeric(charges))) %>%
  mutate(wave2_rate_per_1000 = as.numeric(charges)/1278365*1000) #rate per 1000 using 2016 census data

# Ontario
ontario_data <- master_df %>%
  filter(city == "ontario") %>%
  filter(!is.na(charges)) %>%
  mutate(date_formatted = parse_date_time(date_formatted, c("my"))) %>%
  select(date_formatted, charges, violation) %>%
  print()

ontario_data %>%
  group_by(date_formatted, violation) %>%
  summarize(charges = sum(charges)) %>%
  ggplot(aes(x = as.Date(date_formatted), y = as.numeric(charges), fill = violation)) +
  geom_col() +
  theme_minimal() +
  scale_x_date(breaks = seq(as.Date("2020-03-01"), as.Date("2021-03-01"), by = "1 month"), date_labels = "%b %Y") +
  scale_fill_fish_d(option = "Hypsypops_rubicundus", direction = -1) +
  scale_y_continuous(breaks = seq(0, 1400, by = 250)) +
  theme(axis.text.x = element_text(angle = 0)) +
  theme(legend.position = "top") +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  theme(plot.title = element_text(face = "bold")) +
  labs(x = "", 
       y = "",
       fill = "",
       title = "COVID-19 Related Fines in Ontario",
       subtitle = "March, 2020 - March, 2021. Y-axis indicates number of fines. Shading indicates wave 2.",
       caption = "Data source: Ministry of Attorney General") +
  annotate("rect", xmin = as.Date("2020-08-16"), xmax = as.Date("2021-03-18"), ymin = 0, ymax = Inf, alpha = .2)

ontario_data %>%
  select(date_formatted, charges, violation) %>%
  group_by(date_formatted, violation) %>%
  summarize(total_charges = sum(as.numeric(charges))) %>%
  mutate(monthly_total = sum(total_charges)) %>%
  ungroup() %>%
  mutate(total = sum(total_charges)) %>%
  mutate(percent_total = total_charges/total*100) %>%
  mutate(monthly_perc_total = monthly_total/total*100)

ont_data %>%
  filter(date_formatted == as.Date("2020-10-01") |
           date_formatted == as.Date("2020-11-01") | 
           date_formatted == as.Date("2020-12-01") | 
           date_formatted == as.Date("2021-01-01") |
           date_formatted == as.Date("2021-02-01")) %>%
  summarize(charges = sum(as.numeric(charges))) %>%
  mutate(wave2_rate_per_1000 = as.numeric(charges)/13448494*1000) #rate per 1000 using 2016 census data

# covid active case rate plot
# read in covid19 data
cov_data <- read_csv("covid19-data-april-27-2021.csv") %>%
  select(prname, date, numtotal, numtoday, numconf, avgtotal_last7, numtotal_last7, rateactive) %>%
  filter(!prname %in% c("Repatriated travellers"))

# plot covid active case rates for Canada, Quebec, Ontario, BC, Manitoba, Nova Scotia
cov_data %>%
  filter(date >= "2020-04-01") %>%
  filter(prname %in% c("Canada", "Quebec", "Ontario", "British Columbia", "Manitoba", "Nova Scotia")) %>%
  mutate(prname = factor(prname, levels = c("Canada", "British Columbia", "Manitoba", "Ontario", "Quebec", "Nova Scotia"))) %>%
  ggplot(aes(x = date, y = rateactive)) +
  geom_line(colour = "#094E9F", size = 0.75) +
  facet_wrap(~prname) +
  theme_minimal() +
  scale_x_date(breaks = seq(as.Date("2020-04-01"), as.Date("2021-04-26"), by = "1 month"), date_labels = "%b %Y") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 90, hjust=0.95, vjust=0.2)) +
  theme(plot.title = element_text(face = "bold")) +
  labs(title = "Rate of active COVID-19 cases",
       subtitle = "April 01 2020 - April 26 2021. Shading indicates wave 2 period, as defined in report.",
       caption = "Data source: Government of Canada",
       y = "Rate of active cases",
       x = "") +
  annotate("rect", xmin = as.Date("2020-09-01"), xmax = as.Date("2021-03-31"), ymin = 0, ymax = Inf, alpha = .2)

