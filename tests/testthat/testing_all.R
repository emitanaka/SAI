library(ellmer)

chat <- chat_ollama(model = "llama3.1:8b", seed = 0)

load("data/messy.rda")
load("data/likerts.rda")

# Test function 1 - sai_fct_reorder/emend_fct_reorder
emend_fct_reorder(likerts$likert1, chat = chat) |> levels()
# [1] "Strongly Disagree" "Disagree"          "Somewhat Disagree" "Neutral"           "Somewhat Agree"    "Agree"
# [7] "Strongly Agree"
# Correct!

# Test function 2 - sai_fct_match/emend_fct_match
emend_fct_match(messy$country, levels = c("UK", "USA", "Canada", "Australia", "NZ"), chat = chat)
#  [1] UK        USA       Canada    UK        USA       Canada    UK        USA       NZ        NZ        Australia NZ
# [13] UK        UK        UK        USA       UK        Australia USA       Australia
# Levels: UK USA Canada Australia NZ
# Correct!

# Test function 3 - sai_lvl_match/emend_lvl_match
emend_lvl_match(messy$country, levels = c("Asia", "Europe", "North America", "Oceania", "South America"), chat = chat)
#              UK              US          Canada  United Kingdom             USA     New Zealand              NZ       Australia
# "Europe" "North America" "North America"        "Europe" "North America"       "Oceania"       "Oceania"       "Oceania"
#
# ── Converted by SAI: ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
# original     converted
# 1             UK        Europe
# 2 United Kingdom        Europe
# 3             US North America
# 4         Canada North America
# 5            USA North America
# 6    New Zealand       Oceania
# 7             NZ       Oceania
# 8      Australia       Oceania

# Test function 4 - sai_lvl_sweep/emend_lvl_sweep
emend_lvl_sweep(messy$country, chat = chat)
# UK               US           Canada               UK               US           Canada   United Kingdom
# "United Kingdom"            "USA"         "Canada" "United Kingdom"            "USA"         "Canada" "United Kingdom"
# USA      New Zealand               NZ        Australia      New Zealand               UK   United Kingdom
# "USA"    "New Zealand"    "New Zealand"      "Australia"    "New Zealand" "United Kingdom" "United Kingdom"
# UK               US   United Kingdom        Australia               US        Australia
# "United Kingdom"            "USA" "United Kingdom"      "Australia"            "USA"      "Australia"
#
# ── Converted by SAI: ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
# original      converted
# 1       NZ    New Zealand
# 2       UK United Kingdom
# 3       US            USA
# Correct!!!

# Test function 5 - sai_translate/emend_translate
text <- c("猿も木から落ちる", "你好", "bon appetit")
emend_translate(text, chat = chat)
# [1] "Even monkeys fall from trees." "Hello"                         "Enjoy your meal."
# Correct!!!

# Test function 6 - sai_what_language/emend_what_language
emend_what_language(text, chat = chat)
# [1] "Japanese"           "Chinese (Mandarin)" "French"
# Correct!!!

# Test function 7 - sai_clean_date/emend_clean_date
x <- c("16/02/1997", "20 November 2024", "24 Mar 2022", "2000-01-01", "Jason", "Dec 25, 2030", "12/05/2024")
emend_clean_date(x, chat = chat)
# [1] "1997-02-16" "2024-11-20" "2022-03-24" "2000-01-01" NA           "2030-12-25" "2024-05-12"
# Correct!!!

# Test function 8 - sai_clean_address/emend_clean_address
x <- c("68/150 Acton Road, Acton ACT 2601",
       "655 Jackson St, Dickson ACT 2602",
       "Unit 60 523 Joey Cct, Layton NSW 6500",
       "23/100 de burgh road, Southbank VIC 7800",
       "91 Sullivan pl, Sydney nsw 6600",
       "i don't know the address")
emend_clean_address(x, chat = chat)

