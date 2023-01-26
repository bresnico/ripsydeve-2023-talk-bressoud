# libraries----
library(httr) # https://talks.andrewheiss.com/2022-seacen/presentation/#/title-slide
library(jsonlite)
library(tibble)

# préparer les variables----

unsplash_id <- c(
  "AxLrxJz_sKU",
  "AxLrxJz_sKU",
  "AxLrxJz_sKU"
)

application_id <- "cvtne6r6JhQ2hYh_ZVw80BeNLVrvmDrDqKLP7qOhyyY"

# préparer les outputs----

# id photo 1

temp_var <- unsplash_id[1]

# se connecter à l'API et nourrir les outputs----

# préparation

api_url <- modify_url("https://api.unsplash.com/",
                      path = paste0("photos/",temp_var),
                      query = paste0("client_id=",application_id)
                      )
api_url

GET(url = api_url)

response <- GET (url = api_url)

d <- content(response, as="text", encoding = "UTF-8")

new <- fromJSON(d)

# image pour slides.

new$urls$regular
# https://api.unsplash.com/photos/xyGR1HKVNpY?client_id=cvtne6r6JhQ2hYh_ZVw80BeNLVrvmDrDqKLP7qOhyyY

# Nom auteur

new$user$name
# "Brooke Cagle"

# URL page

new$links$html
# "https://unsplash.com/photos/AxLrxJz_sKU"

# Loop----

unsplash_db <- tibble(unsplash_url = character(),
                      unsplash_name = character(),
                      unsplash_html = character(),
                      credits = character()
                      )

for (i in 1:length(unsplash_id)) {

  temp_var <- unsplash_id[i]

  api_url <- modify_url("https://api.unsplash.com/",
                        path = paste0("photos/",temp_var),
                        query = paste0("client_id=",application_id)
                        )

  response <- GET (url = api_url)

  d <- content(response, as="text", encoding = "UTF-8")

  new <- fromJSON(d)

  unsplash_db <- add_row(unsplash_db,
                         unsplash_url = new$urls$regular,
                         unsplash_name = new$user$name,
                         unsplash_html = new$links$html,
                         credits = paste0("<a href='",new$links$html,"'>",new$user$name,"</a><br>")
                         )
}

unsplash_db$credits[1]

