# reference of country names
# https://en.wikipedia.org/wiki/List_of_sovereign_states
# https://www.dfat.gov.au/geo/country-briefs

library(dplyr)
library(stringr)
#library(SAI)

load("~/GitHub/SAI/data/salary.rda")

# check missing value
salary %>% summarise(missing_values = sum(is.na(salary$country)))

# Retrieve the data column to a vector
data <- salary$country
unique(data)

# convert emoji "🇺🇸" to "united states"
data_clean <- gsub("^(🇺🇸)$", "united states", data)

# convert "A-Z" to lower case
data_clean <- tolower(data_clean)

# remove all the dots in elements
data_clean <- gsub("\\.", "", data_clean)

# remove all ">"
data_clean <- gsub(">", "", data_clean)

# remove "/"
data_clean <- gsub("/", "", data_clean)

# remove ","
data_clean <- gsub(",", "", data_clean)

# remove "-"
data_clean <- gsub("-", "", data_clean)

# remove "("
data_clean <- gsub("\\(", "", data_clean)

# remove ")"
data_clean <- gsub("\\)", "", data_clean)

# remove "$"
data_clean <- gsub("\\$", "", data_clean)

# remove "'"
data_clean <- gsub("'", "", data_clean)

# remove "+"
data_clean <- gsub("\\+", "", data_clean)

# remove leading and trailing white space
data_clean <- trimws(data_clean)

# "united states"
data_clean <- gsub("^(us|usa|united states of america|united state|america|the united states|united state of america|united stated|united statws|unites states|isa|u s|united sates|united states of american|uniited states|united sates of america|unted states|united statesp|united stattes|united statea|united statees|uniyed states|uniyes states|united states of americas|us of a|united status|uniteed states|united stares|unite states|the us|unitedstates|united statew|united statues|untied states|unitied states|united sttes|uniter statez|usa tomorrow|united stateds|unitef stated|united statss|united  states|united states is america|virginia|california|san francisco|hartford|united y|usaa|usat|i work for a uaebased organization though i am personally in the us|usa but for foreign govt|uss|is|ua|usab|usd|usa company is based in a us territory i work remote|worldwide based in us but short term trips aroudn the world|united states i work from home and my clients are all over the uscanadapr|uxz)$", "united states", data_clean)

# "united kingdom"
data_clean <- gsub("^(uk|scotland|england|great britain|northern ireland|britain|englanduk|england uk|united kingdom england|united kindom|uk northern ireland|united kingdomk|wales united kingdom|england gb|uk northern england|england united kingdom|englang|wales|uk england|scotland uk|unites kingdom|wales uk|northern ireland united kingdom|london|uk but for globally fully remote company|uk for us company|uk remote)$", "united kingdom", data_clean)
data_clean <- gsub("^()$", "united kingdom", data_clean)

# "netherlands"
data_clean <- gsub("^(the netherlands|nl|nederland)$", "netherlands", data_clean)

# "canada"
data_clean <- gsub("^(canada ottawa ontario|canadw|canda|canadá|csnada|can|canad|i am located in canada but i work for a company in the us)$", "canada", data_clean)

# "australia"
data_clean <- gsub("^(australian|australi)$", "australia", data_clean)

# "new zealand"
data_clean <- gsub("^(aotearoa new zealand|nz|new zealand aotearoa|from new zealand but on projects across apac)$", "new zealand", data_clean)

# "india"
data_clean <- gsub("^(ibdia)$", "india", data_clean)

# "hong kong"
data_clean <- gsub("^(hong konh)$", "hong kong", data_clean)

# "mexico"
data_clean <- gsub("^(méxico)$", "mexico", data_clean)

# "czech republic"
data_clean <- gsub("^(czechia)$", "czech republic", data_clean)

# "brazil"
data_clean <- gsub("^(brasil)$", "brazil", data_clean)

# "panama"
data_clean <- gsub("^(panamá)$", "panama", data_clean)

# "denmark"
data_clean <- gsub("^(danmark)$", "denmark", data_clean)

# "spain"
data_clean <- gsub("^(catalonia)$", "spain", data_clean)

# "italy"
data_clean <- gsub("^(italy south)$", "italy", data_clean)

# "china"
data_clean <- gsub("^(mainland china)$", "china", data_clean)

# "luxembourg"
data_clean <- gsub("^(luxemburg)$", "luxembourg", data_clean)

# "united arab emirates"
data_clean <- gsub("^(uae)$", "united arab emirates", data_clean)

# "us virgin islands"
data_clean <- gsub("^(usa virgin islands)$", "united states virgin islands", data_clean)

# "japan"
data_clean <- gsub("^(japan us gov position)$", "japan", data_clean)

# "romania"
data_clean <- gsub("^(from romania but for an us based company)$", "romania", data_clean)

# "philippines"
data_clean <- gsub("^(remote philippines)$", "philippines", data_clean)

# "argentina"
data_clean <- gsub("^(argentina but my org is in thailand|i work for an us based company but im from argentina)$", "argentina", data_clean)

# "pakistan"
data_clean <- gsub("^(company in germany i work from pakistan)$", "pakistan", data_clean)

# "puerto rico"
data_clean <- gsub("^(united states puerto rico)$", "puerto rico", data_clean)

# "austria"
data_clean <- gsub("^(austria but i work remotely for a dutchbritish company)$", "austria", data_clean)

# "jersey"
data_clean <- gsub("^(jersey channel islands)$", "jersey", data_clean)

# "myanmar"
data_clean <- gsub("^(burma)$", "myanmar", data_clean)

# "unidentifiable"
data_clean <- gsub("^(europe|loutreland|ff|y|dbfemf|na|ss|remote|international|bonus based on meeting yearly goals set w my supervisor|for the united states government but posted overseas|us govt employee overseas country withheld|na remote from wherever i want|contracts|global|policy|currently finance|canada and usa|217584year is deducted for benefits|we dont get raises we get quarterly bonuses but they periodically asses income in the area you work so i got a raise because a 3rd party assessment showed i was paid too little for the area we were located|i was brought in on this salary to help with the ehr and very quickly was promoted to current position but compensation was not altered|i earn commission on sales if i meet quota im guaranteed another 16k min last year i earned an additional 27k its not uncommon for people in my space to earn 100k after commission|africa)$", "unidentifiable", data_clean)

### to title ###
data_clean <- str_to_title(data_clean)

# correct some country names
data_clean <- gsub("^(Cote Divoire)$", "Cote d'Ivoire", data_clean)
data_clean <- gsub("^(Bosnia And Herzegovina)$", "Bosnia and Herzegovina", data_clean)
data_clean <- gsub("^(Isle Of Man)$", "Isle of Man", data_clean)
data_clean <- gsub("^(Trinidad And Tobago)$", "Trinidad and Tobago", data_clean)

### ground truth get ###
truth <- unique(data_clean)
sort(truth)

### test for llama3.1:8b ###
sai_set_option("model", model_ollama("llama3.1:8b"))
result_llama31_8b <- sai_fct_match(data, levels = truth)

