library(stringr)

fixColnames = function(cols) {
  cols_fixed = str_replace_all(cols, "ê", "e")
  cols_fixed = str_replace_all(cols_fixed, "³", "l")
  cols_fixed = str_replace_all(cols_fixed, "œ", "s")
  cols_fixed = str_replace_all(cols_fixed, "ó", "o")
  cols_fixed = str_replace_all(cols_fixed, "\\.{2}", ".")
  cols_fixed = str_replace_all(cols_fixed, "[[:punct:]]", "_")
  return(cols_fixed)
}

filterInitialData = function(data) {
  filtered_data =
    data %>%
    select(Data_transakcji, Dane_kontrahenta, Tytul, Szczegoly, Kwota_transakcji_waluta_rachunku_, Konto) %>%
    filter(Szczegoly != "")
  return(filtered_data)
}




