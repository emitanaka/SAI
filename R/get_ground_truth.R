# reference of country names
# https://en.wikipedia.org/wiki/List_of_sovereign_states

library(dplyr)
library(stringr)

load("~/GitHub/SAI/data/salary.rda")

# check missing value
salary %>% summarise(missing_values = sum(is.na(salary$country)))

# Retrieve the data column to a vector
data <- salary$country
unique(data) #318

# convert to lower case
data_clean <- tolower(data)
unique(data_clean) #259

# remove all the dots in elements
data_clean <- gsub("\\.", "", data_clean)
unique(data_clean) #247

# remove all ">"
data_clean <- gsub(">", "", data_clean)
unique(data_clean) #246

# remove "/"
data_clean <- gsub("/", "", data_clean)
unique(data_clean) #246

# remove ","
data_clean <- gsub(",", "", data_clean)
unique(data_clean) #246

# remove "-"
data_clean <- gsub("-", "", data_clean)
unique(data_clean) #246

# remove "("
data_clean <- gsub("\\(", "", data_clean)
unique(data_clean) #246

# remove ")"
data_clean <- gsub("\\)", "", data_clean)
unique(data_clean) #245

# remove "$"
data_clean <- gsub("\\$", "", data_clean)
unique(data_clean) #245

# remove leading and trailing white space
data_clean <- trimws(data_clean)
unique(data_clean) #245

# replace variations with "united states"
data_clean <- gsub("^(us|usa|united states of america|united state|america|the united states|united state of america|united stated|united statws|usa virgin islands|unites states|isa|u s|united sates|united states of american|uniited states|united sates of america|unted states|united statesp|united stattes|united statea|united statees|uniyed states|uniyes states|united states of americas|us of a|united status|uniteed states|united stares|unite states|the us|unitedstates|united statew|united statues|untied states|unitied states|united sttes|uniter statez|usa tomorrow|united stateds|unitef stated|united statss|united  states|united states is america|virginia|california|united states puerto rico|san francisco|puerto rico|hartford)$", "united states", data_clean)
unique(data_clean) #202

# replace variations with "united kingdom"
data_clean <- gsub("^(uk|scotland|england|great britain|northern ireland|britain|englanduk|england uk|united kingdom england|united kindom|uk northern ireland|united kingdomk|wales united kingdom|england gb|uk northern england|england united kingdom|englang|wales|uk england|scotland uk|unites kingdom|wales uk|northern ireland united kingdom|london|bermuda|cayman islands|jersey channel islands|isle of man)$", "united kingdom", data_clean)
unique(data_clean) #177

# replace variations with "netherlands"
data_clean <- gsub("^(the netherlands|nl|nederland)$", "netherlands", data_clean)
unique(data_clean) #175

# replace variations with "canada"
data_clean <- gsub("^(canada ottawa ontario|canadw|canda|canadá|csnada|can|canad)$", "canada", data_clean)
unique(data_clean) #170

# replace variations with "australia"
data_clean <- gsub("^(australian|australi)$", "australia", data_clean)
unique(data_clean) #169

# replace variations with "new zealand"
data_clean <- gsub("^(aotearoa new zealand|nz|new zealand aotearoa)$", "new zealand", data_clean)
unique(data_clean) #164

# "india"
data_clean <- gsub("^(ibdia)$", "india", data_clean)
unique(data_clean) #163

# "myanmar"
data_clean <- gsub("^(burma)$", "myanmar", data_clean)
unique(data_clean)

# "hong kong"
data_clean <- gsub("^(hong konh)$", "hong kong", data_clean)
unique(data_clean)

# "mexico"
data_clean <- gsub("^(méxico)$", "mexico", data_clean)
unique(data_clean)

# "czech republic"
data_clean <- gsub("^(czechia)$", "czech republic", data_clean)
unique(data_clean)

# "brazil"
data_clean <- gsub("^(brasil)$", "brazil", data_clean)
unique(data_clean)

# "panama"
data_clean <- gsub("^(panamá)$", "panama", data_clean)
unique(data_clean)

# "denmark"
data_clean <- gsub("^(danmark)$", "denmark", data_clean)
unique(data_clean)

# "spain"
data_clean <- gsub("^(catalonia)$", "spain", data_clean)
unique(data_clean)

# "italy"
data_clean <- gsub("^(italy south)$", "italy", data_clean)
unique(data_clean)

# "china"
data_clean <- gsub("^(mainland china)$", "china", data_clean)
unique(data_clean)

# "luxembourg"
data_clean <- gsub("^(luxemburg)$", "luxembourg", data_clean)
unique(data_clean)

# "ivory coast"
data_clean <- gsub("^(cote d'ivoire)$", "ivory coast", data_clean)
unique(data_clean)

# "united arab emirates"
data_clean <- gsub("^(uae)$", "united arab emirates", data_clean)
unique(data_clean) #140

# have cleaned everything i can find
# the rest are things meaningless so i can't find a correct country name for it
# maybe suggest that we only use rows for US and UK?
# remove other rows
# i think there are enough variations only for US and UK
# also, there are so many islands and territories for US and UK
# should we keep their own name or put it under US or UK

