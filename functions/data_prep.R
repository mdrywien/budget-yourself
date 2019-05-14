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

processTransactionTypes = function(data) {
  data$Szczegoly = str_replace_all(data$Szczegoly, "([^[:alpha:]])", "")
  return(data)
}

deleteMutualLines = function(data) {
  d = data %>% mutate(id = row_number())
  d1 = d %>% mutate(Kwota_transakcji_waluta_rachunku_ = Kwota_transakcji_waluta_rachunku_*(-1))
  to_delete = 
    d %>% 
    inner_join(d1, by = c("Data_transakcji", "Kwota_transakcji_waluta_rachunku_")) %>% 
    filter(Konto.x != Konto.y) %>%
    select(id.x)
  to_delete = to_delete[,1]
  wo_dups = d %>% filter(!id %in% to_delete) %>% select(-id)
  return(wo_dups)
}

sumIn = function(data) {
  data_to_sum = deleteMutualLines(data)
  pos_data = data_to_sum %>% filter(Kwota_transakcji_waluta_rachunku_ >= 0)
  in_sum = sum(pos_data$Kwota_transakcji_waluta_rachunku_)
  return(in_sum)
}

sumOut = function(data) {
  data_to_sum = deleteMutualLines(data)
  neg_data = data_to_sum %>% filter(Kwota_transakcji_waluta_rachunku_ < 0)
  out_sum = sum(neg_data$Kwota_transakcji_waluta_rachunku_)
  return(out_sum)
}
