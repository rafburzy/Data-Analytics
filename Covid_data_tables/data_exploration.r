# loading required packages
library(tidyverse)

# loading the dataset [Attention! this path may need to be modified for your project]
df <- read_csv("./covid-19_analysis/all_data_selected_ctr.csv")

# displaying the dataset head and structure
head(df)
str(df)

# plotting confirmed cases
ggplot(data = df, aes(x = date, y = confirmed_cases)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Confirmed Covid-19 cases in selected countries in 2020") +
  ylab("confirmed cases")

# plotting daily confirmed cases
ggplot(data = df, aes(x = date, y = daily_confirmed_cases)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Covid-19 daily confirmed cases in selected countries in 2020") +
  ylab("number of daily confirmed cases")

# plotting deaths
ggplot(data = df, aes(x = date, y = deaths)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Covid-19 classified deaths in selected countries in 2020") +
  ylab("number of deaths")

# daily deaths
ggplot(data = df, aes(x = date, y = daily_deaths)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Daily Covid-19 classified deaths in selected countries in 2020") +
  ylab("number of daily deaths")

# box plots
ggplot(data = df, aes(x = countries_and_territories, y = daily_confirmed_cases)) +
  geom_boxplot(aes(color = countries_and_territories)) +
  labs(title = "Covid-19 daily confirmed cases in selected countries in 2020") +
  ylab("number of daily confirmed cases")

# histograms
ggplot(data = df, aes(daily_confirmed_cases)) +
  geom_histogram(aes(color = countries_and_territories)) +
  facet_wrap(~countries_and_territories) +
  labs(title = "Covid-19 daily confirmed cases in selected countries in 2020") +
  xlab("number of daily confirmed cases")

# dotplot
ggplot(data = df, aes(daily_confirmed_cases)) +
  geom_dotplot(aes(fill = countries_and_territories), alpha = 0.3, binwidth = 1000) +
  facet_wrap(~countries_and_territories) +
  labs(title = "Covid-19 daily confirmed cases in selected countries in 2020") +
  xlab("number of daily confirmed cases")

# creating new columns for daily data on infections and deaths
df$cases_to_population <- df$daily_confirmed_cases / df$pop_data_2019
df$deaths_to_population <- df$daily_deaths / df$pop_data_2019

# plotting the newly created data
ggplot(data = df, aes(x = date, y = cases_to_population)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Daily confirmed Covid-19 cases vs. population",
       subtitle = "for selected countries in 2020") +
  ylab("daily confirmed cases to population")

ggplot(data = df, aes(x = date, y = deaths_to_population)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Daily deaths vs. population",
       subtitle = "for selected countries in 2020") +
  ylab("daily deaths to population")

# creating new columns for total data on infections and deaths
df$total_cases_to_pop <- (df$confirmed_cases / df$pop_data_2019) * 100
df$total_deaths_to_pop <- (df$deaths / df$pop_data_2019) * 100

ggplot(data = df, aes(x = date, y = total_cases_to_pop)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Total confirmed Covid-19 cases vs. population",
       subtitle = "for selected countries in 2020") +
  ylab("confirmed cases to population [%]")

ggplot(data = df, aes(x = date, y = total_deaths_to_pop)) +
  geom_point(aes(color = countries_and_territories), alpha = 0.3) + 
  labs(title = "Total deaths vs. population",
       subtitle = "for selected countries in 2020") +
  ylab("deaths to population [%]")
