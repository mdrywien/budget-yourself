library(stringr)

fixColnames = function(cols) {
  cols_fixed = str_replace_all(
    str_replace_all(
      str_replace_all(
        str_replace_all(
          str_replace_all(cols, "ê", "e"),
          "³", "l"),
        "ó", "o"),
      "\\.{2}", "."),
    "[[:punct:]]", "_")
  return(cols_fixed)
}

filterInitialData = function(data) {
  filtered_data =
    data %>%
    select(Data_transakcji, Dane_kontrahenta, Tytul, Szczegoly, Kwota_transakcji_waluta_rachunku_, Konto) %>%
    filter(Szczegoly != "")
  return(filtered_data)
}

groupDataByCat = function(data) {
  grouped_data = 
    data %>%
    filter(category != "") %>%
    group_by(Data_transakcji, category) %>%
    select(Data_transakcji, category, Kwota_transakcji_waluta_rachunku_) %>%
    summarise(total_spend = sum(Kwota_transakcji_waluta_rachunku_))
  return(grouped_data)
}




