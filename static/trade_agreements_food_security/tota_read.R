## this script assumes previous download of all the files available in this repository
## https://github.com/mappingtreaties/tota/

if (!fs::file_exists("tota")) {
  if (!fs::file_exists(path = "tota.zip")) {
    download.file(
      url = "https://github.com/mappingtreaties/tota/archive/refs/heads/master.zip",
      destfile = "tota.zip"
    )
  }

  unzip(zipfile = "tota.zip")

  fs::file_move(path = "tota-master", new_path = "tota")
}

if (fs::file_exists("tota.csv.gz")) {
  tota_df <- readr::read_csv(file = "tota.csv.gz")
} else {
  xml_files_v <- tibble::tibble(
    path = fs::dir_ls(path = fs::path("tota", "xml"))
  ) |>
    dplyr::mutate(
      id = stringr::str_extract(
        string = fs::path_file(path),
        pattern = "[[:digit:]]+"
      )
    ) |>
    dplyr::arrange(as.numeric(id)) |>
    dplyr::pull(path)

  extract_treaty_meta <- function(treaty_meta_l) {
    treaty_meta_df <- purrr::map2(
      .x = treaty_meta_l,
      .y = names(treaty_meta_l),
      \(x, y) {
        current_property_v <- c(
          x = x |> unlist() |> stringr::str_flatten(collapse = ";")
        )
        names(current_property_v) <- y
        current_property_v
      }
    ) |>
      tibble::as_tibble(.name_repair = \(x) make.unique(x, sep = "_"))

    treaty_meta_df
  }

  get_name_attr <- purrr::attr_getter(attr = "name") # to prevent partial matching

  tota_df <- purrr::map(
    .progress = TRUE,
    .x = xml_files_v,
    .f = \(current_file) {
      current_treaty_l <- xml2::read_xml(x = current_file) |>
        xml2::as_list()

      current_treaty_id <- current_file |>
        fs::path_file() |>
        fs::path_ext_remove()

      current_treaty_meta_l <- current_treaty_l[["treaty"]][["meta"]]

      treaty_meta_df <- extract_treaty_meta(current_treaty_meta_l)

      current_treaty_body_l <- current_treaty_l[["treaty"]][["body"]]

      treaty_body_df <- purrr::map(
        .x = current_treaty_body_l,
        .f = \(current_chapter) {
          chapter_metadata_df <- tibble::tibble(
            chapter_identifier = attr(current_chapter, "chapter_identifier"),
            chapter_number = attr(current_chapter, "number"),
            chapter_name = get_name_attr(current_chapter)
          )

          current_chapter_df <- purrr::map(
            .x = current_chapter,
            .f = \(current_article) {
              article_metadata_df <- tibble::tibble(
                article_identifier = attr(
                  current_article,
                  "article_identifier"
                ),
                article_name = attr(current_article, "name"),
                article_number = attr(current_article, "number")
              )

              dplyr::bind_cols(
                chapter_metadata_df,
                article_metadata_df,
                tibble::tibble(article_text = unlist(current_article))
              )
            }
          ) |>
            purrr::list_rbind()
        }
      ) |>
        purrr::list_rbind()

      current_treaty_df <- dplyr::bind_cols(treaty_meta_df, treaty_body_df) |>
        dplyr::mutate(
          doc_id = stringr::str_c(current_treaty_id, "_", dplyr::row_number())
        ) |>
        dplyr::rename(text = article_text)

      current_treaty_df
    }
  ) |>
    purrr::list_rbind() |>
    dplyr::relocate(doc_id, text) |>
    dplyr::relocate(
      dplyr::starts_with("related_agreement"),
      .after = last_col()
    ) |>
    dplyr::relocate(dplyr::starts_with("source"), .after = last_col())

  #tif compliant
  #https://docs.ropensci.org/tif/

  readr::write_csv(x = tota_df, file = "tota.csv.gz")
  readODS::write_ods(x = tota_df, path = "tota.ods")
}

if (fs::file_exists("food_security_keywords.csv")) {
  # read the English language keywords selected
  food_security_keywords_df <- readr::read_csv("food_security_keywords.csv")

  food_v <- c(
    food_security_keywords_df$english,
    food_security_keywords_df$spanish,
    food_security_keywords_df$french
  ) |>
    unique()
} else {
  # or create your own list of keywords
  food_v <- c(
    "food aid",
    "food security",
    "famine"
  )
}

# food_v <- c("create", "your", "custom", "list", "of", "keywords")

food_string <- purrr::map_chr(food_v, .f = \(x) {
  stringr::str_flatten(c("\\b", x, "\\b"))
}) |>
  stringr::str_flatten(collapse = "|")


tota_food_df <- tota_df |>
  dplyr::filter(stringr::str_detect(string = text, pattern = food_string)) |>
  dplyr::rowwise() |>
  dplyr::mutate(
    matched = stringr::str_extract_all(
      string = text,
      pattern = food_string,
      simplify = TRUE
    ) |>
      stringr::str_flatten(collapse = ";")
  ) |>
  dplyr::ungroup() |>
  dplyr::relocate(doc_id, text, matched) |>
  dplyr::relocate(
    dplyr::starts_with("related_agreement"),
    .after = last_col()
  ) |>
  dplyr::relocate(dplyr::starts_with("source"), .after = last_col())

## This is a dataset with only sentences including relevant references:

tota_food_df
