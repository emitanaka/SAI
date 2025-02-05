# reference of country names
# https://en.wikipedia.org/wiki/List_of_sovereign_states
# https://www.dfat.gov.au/geo/country-briefs

library(dplyr)
library(stringr)
library(stringdist)
library(SAI)
library(openxlsx)

load("data/salary.rda")
load("data/registration.rda")

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

### lowest accuracy ###
sum(data_clean == data) #13390/28083

### test for amatch() ###
result_amatch_code <- amatch(data, truth, maxDist = Inf)
result_amatch <- truth[result_amatch_code]
sum(data_clean == result_amatch, na.rm = TRUE) #14497

### test for llama3.2:1b ###
# the response is not in json format
# took 1.5 hour to run
start_time <- Sys.time()
sai_set_option("model", model_ollama("llama3.2:1b"))
result_llama32_1b <- sai_fct_match(data, levels = truth)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(result_llama32_1b, "result_llama32_1b.csv", row.names = FALSE)
sum(data_clean == result_llama32_1b, na.rm = TRUE) #11199

### test for llama3.2:3b ###
# run for 1.8 hours
# very low accuracy...
start_time <- Sys.time()
sai_set_option("model", model_ollama("llama3.2"))
result_llama32_3b <- sai_fct_match(data, levels = truth)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(result_llama32_3b, "result_llama32_3b.csv", row.names = FALSE)
sum(data_clean == result_llama32_3b, na.rm = TRUE) #2634

### test for llama3.1:8b ###
# embedding length 4096
sai_set_option("model", model_ollama("llama3.1:8b"))
result_llama31_8b <- sai_fct_match(data, levels = truth)
write.csv(result_llama31_8b, "result_llama31_8b.csv", row.names = FALSE)
sum(data_clean == result_llama31_8b, na.rm = TRUE) #28052

### test for deepseek-r1:1.5b ###
# error subscript out of bound
# maybe because out of context length
# no, i think it's because embedding length
# because the context length of deepseek-r1:1.5b and llama3.1:8b are the same
# embedding length 1536
# deepseek returns answer with a thinking section and emojis
# maybe that's the problem

sai_set_option("model", model_ollama("deepseek-r1:1.5b"))
result_deepseekr1_1dot5b <- sai_fct_match(data, levels = truth)

### test for deepseek-r1:7b ###
# this one no error, so for smaller models embedding length is a problem ###
# embedding length 3584
# no this one didn't work as well, so probably not the embedding length
# same error
# it took me 6 hours to run, then got an error at the end???
sai_set_option("model", model_ollama("deepseek-r1:7b"))
result_deepseekr1_7b <- sai_fct_match(data, levels = truth)

### test for mistral:7b ###
# run for 2.5 hours
start_time <- Sys.time()
sai_set_option("model", model_ollama("mistral"))
result_mistral_7b <- sai_fct_match(data, levels = truth)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(result_mistral_7b, "result_mistral_7b.csv", row.names = FALSE)
sum(data_clean == result_mistral_7b, na.rm = TRUE) #28048

### test for qwen2.5:1.5b ###
# run for 34 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("qwen2.5:1.5b"))
result_qwen25_1dot5b <- sai_fct_match(data, levels = truth)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(result_qwen25_1dot5b, "result_qwen25_1dot5b.csv", row.names = FALSE)
sum(data_clean == result_qwen25_1dot5b, na.rm = TRUE) #12840

### test for qwen2.5:7b ###
# run for 2.64 hours
start_time <- Sys.time()
sai_set_option("model", model_ollama("qwen2.5:7b"))
result_qwen25_7b <- sai_fct_match(data, levels = truth)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(result_qwen25_7b, "result_qwen25_7b.csv", row.names = FALSE)
sum(data_clean == result_qwen25_7b, na.rm = TRUE) #27893

### test for gemma2:2b ###
# error:
# Error in sai_assist(list(prompt_user("For '{x}' (which may be an acronym) return the best match from {levels*}.\n                           Return 'NA' if no match, not confident or not sure.\n                           "),  : subscript out of bounds
start_time <- Sys.time()
sai_set_option("model", model_ollama("gemma2:2b"))
result_gemma2_2b <- sai_fct_match(data, levels = truth)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(result_gemma2_2b, "result_gemma2_2b.csv", row.names = FALSE)
sum(data_clean == result_gemma2_2b, na.rm = TRUE)

### test for phi:2.7b ###
# the response is not in JSON format
# run for 1.5 hours
start_time <- Sys.time()
sai_set_option("model", model_ollama("phi:2.7b"))
result_phi_2dot7b <- sai_fct_match(data, levels = truth)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(result_phi_2dot7b, "result_phi_2dot7b.csv", row.names = FALSE)
sum(data_clean == result_phi_2dot7b, na.rm = TRUE) #3741

### test for yi:6b ###

### test for glm4:9b ###


################# calculate for registration data #########################
reg_truth_levels <- unique(registration$GroundTruth)
truth_registration <- registration$GroundTruth
messy_registration <- registration$Affiliation

### test for amatch() ###
result_reg_amatch_code <- amatch(messy_registration, reg_truth_levels, maxDist = Inf)
result_reg_amatch <- reg_truth_levels[result_reg_amatch_code]
sum(truth_registration == result_reg_amatch, na.rm = TRUE) #83/221

### test for llama3.2:1b ###
# run for 16.9 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("llama3.2:1b"))
reg_result_llama32_1b <- sai_fct_match(messy_registration, levels = reg_truth_levels)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(reg_result_llama32_1b, "results/reg_result_llama32_1b.csv", row.names = FALSE)
sum(truth_registration == reg_result_llama32_1b, na.rm = TRUE) #9/221

### test for llama3.2:3b ###
# run for 19 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("llama3.2"))
reg_result_llama32_3b <- sai_fct_match(messy_registration, levels = reg_truth_levels)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(reg_result_llama32_3b, "results/reg_result_llama32_3b.csv", row.names = FALSE)
sum(truth_registration == reg_result_llama32_3b, na.rm = TRUE) #3/221

### test for llama3.1:8b ###
# run for 31 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("llama3.1:8b"))
reg_result_llama31_8b <- sai_fct_match(messy_registration, levels = reg_truth_levels)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(reg_result_llama31_8b, "results/reg_result_llama31_8b.csv", row.names = FALSE)
sum(truth_registration == reg_result_llama31_8b, na.rm = TRUE) #197/221

### test for mistral:7b ###
# run for 35 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("mistral"))
reg_result_mistral_7b <- sai_fct_match(messy_registration, levels = reg_truth_levels)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(reg_result_mistral_7b, "results/reg_result_mistral_7b.csv", row.names = FALSE)
sum(truth_registration == reg_result_mistral_7b, na.rm = TRUE) #199/221

### test for qwen2.5:1.5b ###
# run for 8 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("qwen2.5:1.5b"))
reg_result_qwen25_1dot5b <- sai_fct_match(messy_registration, levels = reg_truth_levels)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(reg_result_qwen25_1dot5b, "results/reg_result_qwen25_1dot5b.csv", row.names = FALSE)
sum(truth_registration == reg_result_qwen25_1dot5b, na.rm = TRUE) #154/221

### test for qwen2.5:7b ###
# run for 40 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("qwen2.5:7b"))
reg_result_qwen25_7b <- sai_fct_match(messy_registration, levels = reg_truth_levels)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(reg_result_qwen25_7b, "results/reg_result_qwen25_7b.csv", row.names = FALSE)
sum(truth_registration == reg_result_qwen25_7b, na.rm = TRUE) #159/221

### test for phi:2.7b ###
# the response is not in JSON format
# run for 25 mins
start_time <- Sys.time()
sai_set_option("model", model_ollama("phi:2.7b"))
reg_result_phi_2dot7b <- sai_fct_match(messy_registration, levels = reg_truth_levels)
end_time <- Sys.time()
execution_time <- end_time - start_time
print(execution_time)

write.csv(reg_result_phi_2dot7b, "results/reg_result_phi_2dot7b.csv", row.names = FALSE)
sum(truth_registration == reg_result_phi_2dot7b, na.rm = TRUE) #5/221

### lowest accuracy ###
sum(messy_registration == truth_registration) #47/221
