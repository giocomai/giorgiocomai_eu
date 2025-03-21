
---
title: "Gmaps"
---

# Extracting data from Google Maps

Google Maps does not allow to extract all the street names for a given country, or all streets with a given name in a country. While there may be more efficient ways (suggestions welcome), we proceed by extracting all the names of villages, towns and cities in relevant region from OpenStreetMap, and then query Google Maps for Tito street (or similar) in each of them.

## Extracting all places OpenStreetMap

We use previously downloaded OpenStreetMap dumps with different filters.


```r
# filter only places
dir.create(path = file.path("data", "o5m-places"), showWarnings = FALSE)

for (i in countries) {
  if (file.exists(file.path("data", "o5m-places", paste0(i, "-places.o5m")))==FALSE) {
    system(paste0('./osmfilter data/o5m/', i, '-latest.o5m --keep="place=*" --drop-version > ', 'data/o5m-places/', i, '-places.o5m'))
  }
}

# export to csv only street type, name, and lon/lat

dir.create(path = file.path("data", "csv-places"), showWarnings = FALSE)

for (i in countries) {
  if (file.exists(file.path("data", "csv-places", paste0(i, "-places.csv")))==FALSE) {
    system(paste0('./osmconvert64 data/o5m-places/', i, '-places.o5m --all-to-nodes --csv="@id @lat @lon place name" > data/csv-places/', i, '-places.csv', " --csv-separator='; '"))
  }
}

all_places <- data_frame()
for (i in countries) {
  # Import from csv
  places <- read_delim(file = file.path("data", "csv-places", paste0(i, "-places.csv")), delim = "; ", col_names = FALSE, locale = locale(decimal_mark = "."), trim_ws = TRUE)
  places <- cbind(places, i)
  all_places <- bind_rows(all_places, places)
}
colnames(all_places)  <- c("id", "lat", "lon", "place", "name", "country")

all_places <- all_places %>% filter(is.na(name)==FALSE) 

ExportData(data = all_places, "all_places")
```


The data are available as a spreadsheet in [.csv](data/all_places.csv), [.xlsx](data/all_places.xlsx), and as a data frame in R's [.rds format](data/all_places.rds).

This filter provides a list of 43826 place names; testing mutiple street names for each of them would require a large (and costly) number of queries to the Google Api. We can therefore filter the data in order to include only place names that are tagged as [city](http://wiki.openstreetmap.org/wiki/Tag:place%3Dcity), [town](http://wiki.openstreetmap.org/wiki/Tag:place%3Dtown), [suburb](http://wiki.openstreetmap.org/wiki/Tag:place%3Dsuburb), or [village](http://wiki.openstreetmap.org/wiki/Tag:place%3Dvillage). This should include all inhabited locations with more than 1000 residents, and exclude places tagged as "locality", "isolated_dwelling", and "hamlet", which are expected to be mostly irrelevant. 


```r
# http://wiki.openstreetmap.org/wiki/Tag:place%3Dvillage

all_places_over1000 <- all_places %>% filter(is.na(name)==FALSE) %>% filter(place == "city" | place == "town" | place == "suburb" | place == "village") %>%  distinct()
```

This more restrictive filter provides a sizable, but somewhat more managable dataset of 25881 place names.


The data are available as a spreadsheet in [.csv](data/all_places_over1000.csv), [.xlsx](data/all_places_over1000.xlsx), and as a data frame in R's [.rds format](data/all_places_over1000.rds).

## What are potential street names that should be queried?

By simply querying "tito" for all place names emerging from the filter, we would likely still receive meaningful results. However, querying for potential street names should give more accurate results. We can base a list of potential street names in each country on previously extracted OpenStreetMaps data. 


```r
OSM_tito_all <- ImportData("OSM_tito_all")

for (i in unique(OSM_tito_all$country)) {
  ShowTable(
    OSM_tito_all %>% filter(country==i) %>% select(streetname, country) %>% count(streetname, country, sort = TRUE) %>% select(streetname, n, country)
  )
}
```


----------------------------------------
       streetname          n   country  
------------------------- --- ----------
      Titova ulica         3   slovenia 

   Cesta maršala Tita      2   slovenia 

      Titova cesta         2   slovenia 

    Trg maršala Tita       2   slovenia 

       Titov most          1   slovenia 

        Titov trg          1   slovenia 

 Titov trg / Piazza Tito   1   slovenia 

    Titova - Nasipna       1   slovenia 

 Ulica Josipa Broza-Tita   1   slovenia 
----------------------------------------


---------------------------------------
       streetname          n   country 
------------------------- --- ---------
      Maršala Tita         6   croatia 

   Ulica Maršala Tita      4   croatia 

   Obala Maršala Tita      2   croatia 

        Titov trg          2   croatia 

 Hodaliste marsala tita    1   croatia 

    Josipa Broza Tita      1   croatia 

 Obala Josipa Broza Tita   1   croatia 

      Obala m. Tita        1   croatia 

  Poljana maršala Tita     1   croatia 

     Trg J. B. Tita        1   croatia 

  Trg Josipa Broza Tita    1   croatia 

    Trg maršala Tita       1   croatia 

    Trg Maršala Tita       1   croatia 

 Ulica Josipa Broza Tita   1   croatia 

 Ulica Josipa Broza-Tita   1   croatia 
---------------------------------------


----------------------------------------------------------
           streetname             n         country       
-------------------------------- ---- --------------------
          Maršala Tita            11   bosnia-herzegovina 

             Titova               4    bosnia-herzegovina 

 Titova ili Put Oficirske Škole   1    bosnia-herzegovina 

        Trg maršala Tita          1    bosnia-herzegovina 

        Ul Maršala Tita           1    bosnia-herzegovina 

        ul. Maršala Tita          1    bosnia-herzegovina 
----------------------------------------------------------


----------------------------------
     streetname       n   country 
-------------------- --- ---------
    Maršala Tita      5   serbia  

    Титоградска       4   serbia  

 Aleja Maršala Tita   1   serbia  

    Marsala Tita      1   serbia  

 Ulica Marsala Tita   1   serbia  

    Тито Маршал       1   serbia  

       Титова         1   serbia  
----------------------------------


------------------------------------------------
          streetname             n    country   
------------------------------- --- ------------
         Marsala Tita            2   montenegro 

 Gjergj Kastrioti - Skënderbeu   1   montenegro 
         / Maršal Tito                          

       Josipa Broza Tita         1   montenegro 

         Maršala Tita            1   montenegro 

        Titove Korenice          1   montenegro 

       trg Maršala Tita          1   montenegro 
------------------------------------------------


------------------------------------
    streetname       n     country  
------------------- ---- -----------
    Маршал Тито      14   macedonia 

 bul. Marsal Tito    1    macedonia 

    Marsal Tito      1    macedonia 

   Marshal Tito      1    macedonia 

 ul. Marshal Tito    1    macedonia 

  Кеј Маршал Тито    1    macedonia 

 Титова Митровачка   1    macedonia 

    Титовелешка      1    macedonia 

   Титово Ужице      1    macedonia 

  ул. Маршал Тито    1    macedonia 

 Улица Маршал Тито   1    macedonia 
------------------------------------

Considering that if Google Maps does not find exact matches, it offers a similar result (and accordingly deals with transliteration when needed), querying for 'Titov' and 'Maršala Tita' should provide an almost complete set of cases.

Shortcomings of this approach: 

- if there are towns/villages with same name, in the same country, but in different region, only one is counted (Google decides which)
- if there is more than one street in the same village with similar name (say, both a "Marshal Tito street" and a "Marshal Tito Boulevard"), then only one is counted.

## Finding "titov"" on Google Maps


```r
 all_places_over1000 <- all_places_over1000 %>% filter(is.na(name)==FALSE) %>%  distinct(name, country, .keep_all = TRUE)

titovQuery <- paste("titov", all_places_over1000$name, all_places_over1000$country, sep = ", ")
```

This is the kind of queries that will be made:


```r
ShowTable(head(data_frame(Query = titovQuery)))
```


----------------------------
           Query            
----------------------------
 titov, Ljubljana, slovenia 

  titov, Banovci, slovenia  

 titov, Postojna, slovenia  

   titov, Piran, slovenia   

   titov, Izola, slovenia   

   titov, Kranj, slovenia   
----------------------------

Google Maps API has a daily quota of 2500 free queries per day. We can either make 2500 queries per day (it would take more than a week for checking only "Titov" streets) or pay the 0.50 USD/per 1000 queries fee. In this case, querying for all "Titov" streets should cost less than 10 USD.


```r
### if using API, uncomment this section

# saveRDS(object = "<API>", file = "GoogleApiKey.rds")
# register_google(key = readRDS("GoogleApiKey.rds"), account_type = "premium", day_limit = 50000)

## this just prepares a properly structured data frame
# titovResults <- cbind(geocode("Titov, Sarajevo, Bosnia and Herzegovina", output='more', messaging=TRUE, override_limit=TRUE), Query = "Maršala Tita, Sarajevo, Bosnia and Herzegovina")

# if (file.exists(file.path("data", "titovResults.rds")==FALSE)) {
#   for (i in seq_along(titovQuery)) {
#     temp <- try(geocode(location = titovQuery[i], output='more', messaging=TRUE))
#     Sys.sleep(time = 1.5) #wait in order to stay within API limits
#     if (is.na(temp$lon)==FALSE) {
#       temp <- cbind(temp, Query = titovQuery[i])
#       titovResults <- bind_rows(titovResults, temp)
#       # saves the results as the process goes (just in case)
#       ExportData(data = titovResults, filename = "titovResults", xlsx = FALSE)
#     }
#   }
# }
```



```r
### This makes only the number of queries allowed in a given day, then it stops. 
### If you re-run this another day it will pick up from where it left.



dir.create(path = "temp", showWarnings = FALSE)
# do nothing if already no free queries available
if (geocodeQueryCheck()>1) {
  if (file.exists(file.path("data", "titovResults.rds"))==FALSE) {
    #this simply aims to prepare a properly structured data frame
    titovResults <- cbind(geocode("Titov, Sarajevo, Bosnia and Herzegovina", output='more'),
                          Query = "Titov, Sarajevo, Bosnia and Herzegovina", QueryId = 0)
    start <- sum(titovProgressId, 1)
    stop <- sum(titovProgressId, geocodeQueryCheck())
    if (stop>length(titovQuery)) {
      stop <- length(titovQuery)
    }
    temp <- data_frame(lon = "")
    for (i in start:stop) {
      temp <- geocode(location = titovQuery[i], output='more', messaging=FALSE)
      Sys.sleep(time = 1.5) #wait in order to stay within API limits
      if (is.na(temp$lon)==FALSE) {
        temp <- cbind(temp, Query = titovQuery[i], QueryId = i)
        titovResults <- bind_rows(titovResults, temp)
        # saves the results as the process goes (just in case)
        ExportData(data = titovResults, filename = "titovResults", xlsx = FALSE, showDataLink = FALSE)
      }
      saveRDS(object = i, file = file.path("temp", "titovProgressId.rds"))
    }
  } else {
    # If this script has already been run, start from where it was last interrupted due to query limit
    titovResults <- ImportData(filename = "titovResults")
    titovProgressId <- readRDS(file = file.path("temp", "titovProgressId.rds"))
    if (titovProgressId<length(titovQuery)) {
      start <- sum(titovProgressId, 1)
      stop <- sum(titovProgressId, geocodeQueryCheck())
      if (stop>length(titovQuery)) {
        stop <- length(titovQuery)
      }
      temp <- data_frame(lon = "")
      for (i in start:stop) {
        # If it receives an "over_query_limit" warning then skip
        if (temp$lon!="OVER_QUERY_LIMIT") {
          # makes sure over quota is properly dealt with: if over quota, just skips
          temp <- tryCatch(expr = geocode(location = titovQuery[i], output='more', messaging=FALSE), warning = function(w) {
            msg <- conditionMessage(w)
            if (grepl(pattern = "OVER_QUERY_LIMIT", x = msg) == TRUE) {
              return(data_frame(lon = "OVER_QUERY_LIMIT", lat = "OVER_QUERY_LIMIT"))
            } else if (grepl(pattern = "ZERO_RESULTS", x = msg) == TRUE) {
              return(data_frame(lon = "ZERO_RESULTS", lat = "ZERO_RESULTS"))
            } else {
              return(data_frame(lon = msg, lat = msg))
            }
          })
          if (temp$lon=="OVER_QUERY_LIMIT") {
            # do nothing really
          } else {
            Sys.sleep(time = 1.5) #wait in order to stay within API limits
            if (is.na(temp$lon)==FALSE & temp$lon!="ZERO_RESULTS") {
              temp <- cbind(temp, Query = titovQuery[i], QueryId = i)
              titovResults <- bind_rows(titovResults, temp)
              # saves the results as the process goes, so it can be stopped anytime and nothing is lost
              ExportData(data = titovResults, filename = "titovResults", xlsx = FALSE, showDataLink = FALSE)
            }
            saveRDS(object = i, file = file.path("temp", "titovProgressId.rds"))
          }
        }
      }
    }
  }
}
```


## Querying separately for 'Marshal tito' ('Маршал Тито')

Given the "popularity" of Maršala Tita/Маршал Тито, even if many have been already captured by querying for Titov, the same process is now repeated for Maršala Tita ('Маршал Тито' in Macedonia).
Here are some examples of the queries that will be made.


```r
marsalaTitaQuery <- paste("Maršala Tita", all_places_over1000$name, all_places_over1000$country, sep = ", ")
marsalaTitaQuery[grepl(pattern = ", macedonia", x = marsalaTitaQuery)] <- gsub(pattern = "Maršala Tita, ", replacement = "Маршал Тито, ", marsalaTitaQuery[grepl(pattern = ", macedonia", x = marsalaTitaQuery)])

head(x = marsalaTitaQuery)
```

[1] "Maršala Tita, Ljubljana, slovenia" "Maršala Tita, Banovci, slovenia"  
[3] "Maršala Tita, Postojna, slovenia"  "Maršala Tita, Piran, slovenia"    
[5] "Maršala Tita, Izola, slovenia"     "Maršala Tita, Kranj, slovenia"    

```r
head(x = marsalaTitaQuery[grepl(pattern = ", macedonia", x = marsalaTitaQuery)])
```

[1] "Маршал Тито, Гевгелија, macedonia" "Маршал Тито, Скопје, macedonia"   
[3] "Маршал Тито, Струмица, macedonia"  "Маршал Тито, Неготино, macedonia" 
[5] "Маршал Тито, Габрене, macedonia"   "Маршал Тито, Струга, macedonia"   


```r
dir.create(path = "temp", showWarnings = FALSE)
# do nothing if already no free queries available
if (geocodeQueryCheck()>1) {
  if (file.exists(file.path("data", "marsalaTitaResults.rds"))==FALSE) {
    #this simply aims to prepare a properly structured data frame
    marsalaTitaResults <- cbind(geocode("Maršala Tita, Sarajevo, Bosnia and Herzegovina", output='more'), Query = "Maršala Tita, Sarajevo, Bosnia and Herzegovina", QueryId = 0)
    start <- sum(1)
    stop <- geocodeQueryCheck()
    if (stop>length(marsalaTitaQuery)) {
      stop <- length(marsalaTitaQuery)
    }
    temp <- data_frame(lon = "")
    for (i in start:stop) {
      temp <- geocode(location = marsalaTitaQuery[i], output='more', messaging=FALSE)
      Sys.sleep(time = 1.5) #wait in order to stay within API limits
      if (is.na(temp$lon)==FALSE) {
        temp <- cbind(temp, Query = marsalaTitaQuery[i], QueryId = i)
        marsalaTitaResults <- bind_rows(marsalaTitaResults, temp)
        # saves the results as the process goes (just in case)
        ExportData(data = marsalaTitaResults, filename = "marsalaTitaResults", xlsx = FALSE, showDataLink = FALSE)
      }
      saveRDS(object = i, file = file.path("temp", "marsalaTitaProgressId.rds"))
    }
  } else {
    # If this script has already been run, start from where it was last interrupted due to query limit
    marsalaTitaResults <- ImportData(filename = "marsalaTitaResults")
    marsalaTitaProgressId <- readRDS(file = file.path("temp", "marsalaTitaProgressId.rds"))
    if (marsalaTitaProgressId<length(marsalaTitaQuery)) {
      start <- sum(marsalaTitaProgressId, 1)
      stop <- sum(marsalaTitaProgressId, geocodeQueryCheck())
      if (stop>length(marsalaTitaQuery)) {
        stop <- length(marsalaTitaQuery)
      }
      temp <- data_frame(lon = "")
      if (start!=stop) {
        for (i in start:stop) {
          # If it receives an "over_quey limit" warning then skip
          if (temp$lon!="OVER_QUERY_LIMIT") {
            # makes sure over quota is properly dealt with: if over quota, just skips
            temp <- tryCatch(expr = geocode(location = marsalaTitaQuery[i], output='more', messaging=FALSE), warning = function(w) {
              msg <- conditionMessage(w)
              if (grepl(pattern = "OVER_QUERY_LIMIT", x = msg) == TRUE) {
                return(data_frame(lon = "OVER_QUERY_LIMIT", lat = "OVER_QUERY_LIMIT"))
              } else if (grepl(pattern = "ZERO_RESULTS", x = msg) == TRUE) {
                return(data_frame(lon = "ZERO_RESULTS", lat = "ZERO_RESULTS"))
              } else {
                return(data_frame(lon = msg, lat = msg))
              }
            })
            if (temp$lon=="OVER_QUERY_LIMIT") {
              # do nothing really
            } else {
              Sys.sleep(time = 1.5) #wait in order to stay within API limits
              if (is.na(temp$lon)==FALSE & temp$lon!="ZERO_RESULTS") {
                temp <- cbind(temp, Query = marsalaTitaQuery[i], QueryId = i)
                marsalaTitaResults <- bind_rows(marsalaTitaResults, temp)
                # saves the results as the process goes, so it can be stopped anytime and nothing is lost
                ExportData(data = marsalaTitaResults, filename = "marsalaTitaResults", xlsx = FALSE, showDataLink = FALSE)
              }
              saveRDS(object = i, file = file.path("temp", "marsalaTitaProgressId.rds"))
            }
          }
        }
      }
    }
  }
}
```


## Polishing the results

Removing results included multiple times, and results that are not streets or squares.


```r
titovResults <- ImportData(filename = "titovResults") 
marsalaTitaResults <- ImportData(filename = "marsalaTitaResults" )

TitoGmapsResults <- bind_rows(titovResults, marsalaTitaResults) %>% 
  filter(type=="route", country != "Italy") %>% # exclude non-YU and non streets/squares
  filter(grepl(pattern = "Tit|Tит", x = route)) %>% # remove most non-tito
  filter(!grepl(pattern = "Strozzi|Brezova", x = route)) %>%  # remove remaining non-Tito
  distinct(address, .keep_all = TRUE) %>% # remove those with same address
  distinct(locality, route, .keep_all = TRUE) %>% #remove same locality, same street name
  distinct(lon, lat, route) 

ExportData(data = TitoGmapsResults, filename = "TitoGmapsResults")
```


The data are available as a spreadsheet in [.csv](data/TitoGmapsResults.csv), [.xlsx](data/TitoGmapsResults.xlsx), and as a data frame in R's [.rds format](data/TitoGmapsResults.rds).

