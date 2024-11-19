



########## code to generate messy address data ################

# Set seed for reproducibility
set.seed(123)

# Sample data: Suburbs and corresponding streets in Canberra
suburbs <- c("Braddon", "Hackett", "Weetangera", "Bruce", "Duffy")
streets <- list(
  Braddon = c("Ainslie Avenue", "Mort Street", "Lonsdale Street"),
  Hackett = c("Maitland Street", "Madigan Street", "Rivett Street"),
  Weetangera = c("Gillespie Street", "Mayo Street", "McLachlan Street"),
  Bruce = c("Battye Street", "Purdie Street", "Leverrier Street"),
  Duffy = c("Eucumbene Drive", "Tantangara Street", "Burrinjuck Crescent")
)
state <- "ACT"
postcodes <- c("2612", "2602", "2614", "2617", "2611")

# Function to generate messy addresses
generate_messy_address <- function() {
  # Randomly generate components
  unit_number <- sample(c(paste("Unit", sample(1:100, 1)), ""), 1) # Sometimes unit is missing
  street_number <- sample(1:999, 1) # Random street number
  suburb <- sample(suburbs, 1)
  street <- sample(streets[[suburb]], 1)
  postcode <- sample(c(postcodes, ""), 1) # Sometimes postcode is missing

  # Include "unit/street_number" variation
  unit_street_combo <- sample(
    c(
      paste(unit_number, street_number),            # Separate unit and street number
      paste(unit_number, "/", street_number),       # Unit/Street Number format
      street_number                                 # No unit, only street number
    ),
    1
  )

  # Combine components into various formats to create messiness
  address <- sample(c(
    paste(unit_street_combo, street, suburb, state, postcode),         # Full address
    paste(unit_street_combo, street, suburb, postcode),                # Missing state
    paste(unit_street_combo, street, suburb),                          # Missing postcode
    paste(unit_street_combo, gsub(" ", "", street), suburb, state, postcode), # Missing spaces in street
    paste(tolower(unit_street_combo), street, tolower(suburb), state, postcode), # Lowercase
    paste(unit_street_combo, street, suburb, state, paste0(" ", postcode)), # Extra space in postcode
    paste(unit_street_combo, street, suburb, state, substr(postcode, 1, 3)), # Partial postcode
    paste(unit_street_combo, " ", street, " ", suburb, " ", state, " ", postcode), # Extra spaces
    paste(unit_street_combo, gsub("Street", "St", street), suburb, state, postcode) # Abbreviated street type
  ), 1)

  return(address)
}

# Generate a dataset of messy addresses
messy_addresses <- data.frame(
  ID = 1:20,
  Address = replicate(20, generate_messy_address())
)

# View the messy address dataset
print(messy_addresses)

sai_clean_address <- function(address_vector, output_format = "", copy = FALSE, ...){
  out <- sai_assist(
    c(list("The input data {address_vector*} is a vector of messy addresses.
            You need to standardise the input data to a consistent format.
            For example,
            Input: 'Unit 31 / 179 Mayo Street, Weetangera ACT 2602',
            Ouput: '31/179 Mayo Street, Weetangera ACT 2602'.
            Only return the output address in a vector format.
            If the input is not address, return NA.")),
    format = "json")
  if(copy) clipr::write_clip(paste0(deparse(out), collapse = ""))
  out
}

sai_clean_address(messy_addresses$Address)

