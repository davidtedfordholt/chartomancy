library(tidyverse)
library(shiny)
library(tsibble)
library(feasts)
library(fable)

past <- tsibbledata::gafa_stock %>%
    select(Symbol, Date, Adj_Close) %>%
    rename(
        key = Symbol,
        x = Date,
        y = Adj_Close
    )

keys <- unique(past$key)
