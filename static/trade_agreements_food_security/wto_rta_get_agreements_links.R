remotes::install_github("giocomai/castarter")
library("castarter")

# export from https://rtais.wto.org/UI/PublicMaintainRTAHome.aspx
# From menu "explore the data" -> "export all RTAs"

# set base folder where pages from the WTO RTA database website will be cached
base_folder <- fs::path(fs::path_home_r(), "R", "castarter_trade_agreements")

cas_set_options(
  base_folder = base_folder,
  project = "trade_agreements",
  website = "rtais_wto"
)

rta_df <- readr::read_csv(
  file = fs::path("wto_rta_db_original.csv"),
  show_col_types = FALSE
) |>
  dplyr::arrange(`RTA ID`)

treaty_urls_v <- paste0(
  "https://rtais.wto.org/UI/PublicShowRTAIDCard.aspx?rtaid=",
  rta_df[["RTA ID"]]
)

cas_write_db_urls(urls = treaty_urls_v)

cas_download()

extractors_l <- list(
  agreement_name = \(x) {
    cas_extract_html(
      html_document = x,
      container = "span",
      container_id = "ContentPlaceHolder1_showRelAggreement_RTAIdCardTabContainer_BasicInfoTbPanel_txtEngAgrName"
    )
  },
  status = \(x) {
    cas_extract_html(
      html_document = x,
      container = "span",
      container_id = "ContentPlaceHolder1_showRelAggreement_RTAIdCardTabContainer_BasicInfoTbPanel_selStatus"
    ) |>
      stringr::str_remove(pattern = "Status:\r\t\r\r ")
  },
  agreement_text_en = \(x) {
    cas_extract_html(
      html_document = x,
      container = "a",
      container_id = "ContentPlaceHolder1_showRelAggreement_RTAIdCardTabContainer_BasicInfoTbPanel_rptTOAList_EngTOAHyperLink_0",
      attribute = "href"
    )
  },
  agreement_text_fr = \(x) {
    cas_extract_html(
      html_document = x,
      container = "a",
      container_id = "ContentPlaceHolder1_showRelAggreement_RTAIdCardTabContainer_BasicInfoTbPanel_rptTOAList_FrTOAHyperLink_0",
      attribute = "href"
    )
  },
  agreement_text_es = \(x) {
    cas_extract_html(
      html_document = x,
      container = "a",
      container_id = "ContentPlaceHolder1_showRelAggreement_RTAIdCardTabContainer_BasicInfoTbPanel_rptTOAList_SpTOAHyperLink_0",
      attribute = "href"
    )
  }
)

get_rta_id <- function(x) {
  x |>
    dplyr::mutate(
      `RTA ID` = stringr::str_extract(url, pattern = "[[:digit:]]+$")
    )
}

cas_extract(
  extractors = extractors_l,
  post_processing = get_rta_id,
  write_to_db = TRUE
)

rtais_wto_df <- cas_read_db_contents_data() |>
  dplyr::collect() |>
  dplyr::rename(rta_id = `RTA ID`) |>
  dplyr::relocate(rta_id, agreement_name, .before = id) |>
  dplyr::select(-id)

rtais_wto_df


readr::write_csv(
  x = rtais_wto_df,
  file = fs::path("wto_rta_download_links.csv")
)

rtais_wto_df |>
  readODS::write_ods(path = fs::path("wto_rta_download_links.ods"))
