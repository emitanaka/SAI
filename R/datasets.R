#' A collection of different likert scales
#'
#' A data set containing 9 different likert scales.
#'
#' @format
#' A data.frame with 40 rows and 9 columns
#' \describe{
#' \item{likert1}{A 7-point agreeableness likert scale.}
#' \item{likert2}{A 5-point agreeableness likert scale.}
#' \item{likert3}{A 5-point agreeableness likert scale as a sentence.}
#' \item{likert4}{A 5-point frequency likert scale.}
#' \item{likert5}{A 5-point rating likert scale.}
#' \item{likert6}{A 5-point likelihood likert scale.}
#' \item{likert7}{A 5-point likert scale.}
#' \item{likert8}{A 5-point satisfaction likert scale.}
#' \item{likert9}{A 6-point priority likert scale.}
#' }
#'
"likerts"

#' A collection of messy inputs
#'
#' A synthetic dataset that contains inputs with some common standardisation
#' issues.
#'
#' @format
#' A list of 3 character vectors
#' \describe{
#'  \item{country}{A character vector of countries.}
#'  \item{suburb}{A character vector of suburbs in Australia with various typos.}
#'  \item{school}{A character vector of schools or college (with typos) at the Australian National University.}
#' }
"messy"

#' Airbnb listings and reviews
#'
#' A sample dataset of Airbnb listings and reviews
#' of properties from Sydney, Australia.
#'
#' @format ## `airbnb_listings`
#' A data.frame with 1623 rows and 68 columns
#' \describe{
#'  \item{id}{Airbnb's unique identifier for the listing.}
#'  \item{name}{Name of the listing.}
#'  \item{description}{Detailed description of the listing.}
#'  \item{neighborhood_overview}{Host's description of the neighbourhood.}
#'  \item{picture_url}{URL to the Airbnb hosted regular sized image for the listing.}
#'  \item{host_id}{Airbnb's unique identifier for the host/user.}
#'  \item{host_name}{Name of the host. Usually just the first name(s).}
#'  \item{host_since}{The date the host/user was created. For hosts that are Airbnb guests this could be the date they registered as a guest.}
#'  \item{host_location}{The host's self reported location.}
#'  \item{host_about}{Description about the host.}
#'  \item{host_response_time}{The time interval between when a host responds to an inquiry from a guest.}
#'  \item{host_response_rate}{Percentage of inquiries from potential guests that are responded to by hosts.}
#'  \item{host_acceptance_rate}{That rate at which a host accepts booking requests.}
#'  \item{host_is_superhost}{Whether the host is a super host or not.}
#'  \item{host_thumbnail_url}{A thumbnail of the host.}
#'  \item{host_picture_url}{A URL to the picture of the host.}
#'  \item{host_neighbourhood}{The host neighbourhood.}
#'  \item{host_listings_count}{The number of listings the host has.}
#'  \item{host_total_listings_count}{The number of listings the host has.}
#'  \item{host_verifications}{Host communication verifications.}
#'  \item{host_has_profile_pic}{Whether the host has a profile pic.}
#'  \item{host_identity_verified}{Whether the host has their identity verified.}
#'  \item{neighbourhood_cleansed}{The neighbourhood as geocoded using the latitude and longitude against neighborhoods as defined by open or public digital shapefiles.}
#'  \item{latitude}{Uses the World Geodetic System (WGS84) projection for latitude and longitude.}
#'  \item{longitude}{Uses the World Geodetic System (WGS84) projection for latitude and longitude.}
#'  \item{property_type}{Self selected property type. Hotels and Bed and Breakfasts are described as such by their hosts in this field.}
#'  \item{room_type}{Entire home/apt, Private room, Shared room, or Hotel. Entire places are best if you're seeking a home away from home. With an entire place, you'll have the whole space to yourself. This usually includes a bedroom, a bathroom, a kitchen, and a separate, dedicated entrance.
#'  Hosts should note in the description if they'll be on the property or not (ex: "Host occupies first floor of the home"), and
#'  provide further details on the listing. Private rooms are great for when you prefer a little privacy, and still value a local connection. When you book a private room, you'll have your own private room for sleeping and may share some spaces with others. You might need to walk through indoor spaces that another host or guest may occupy to get to your room. Shared rooms are for when you don't mind sharing a space with others. When you book a shared room, you'll be sleeping in a space that is shared with others and share the entire space with other people. Shared rooms are popular among flexible travelers looking for new friends and budget-friendly stays.}
#'  \item{accommodates}{The maximum capacity of the listing.}
#'  \item{bathrooms}{The number of bathrooms in the listing.}
#'  \item{bathrooms_text}{The text of the number of bathsroom in the listings.}
#'  \item{bedrooms}{The number of bedrooms.}
#'  \item{beds}{The number of bed(s).}
#'  \item{amenities}{The amenities.}
#'  \item{price}{Daily price in local currency.}
#'  \item{minimum_nights}{Minimum number of night stay for the listing.}
#'  \item{maximum_nights}{Maximum number of night stay for the listing.}
#'  \item{minimum_minimum_nights}{The smallest minimum_night value from the calender (looking 365 nights in the future).}
#'  \item{maximum_minimum_nights}{The largest minimum_night value from the calender (looking 365 nights in the future).}
#'  \item{minimum_maximum_nights}{The smallest maximum_night value from the calender (looking 365 nights in the future).}
#'  \item{maximum_maximum_nights}{The largest maximum_night value from the calender (looking 365 nights in the future).}
#'  \item{minimum_nights_avg_ntm}{The average minimum_night value from the calender (looking 365 nights in the future).}
#'  \item{maximum_nights_avg_ntm}{The average maximum_night value from the calender (looking 365 nights in the future).}
#'  \item{has_availability}{Whether there is availability or not.}
#'  \item{availability_30}{The availability of the listing x days in the future as determined by the calendar. Note a listing may not be available because it has been booked by a guest or blocked by the host.}
#'  \item{availability_60}{}
#'  \item{availability_90}{}
#'  \item{availability_365}{}
#'  \item{number_of_reviews}{The number of reviews the listing has.}
#'  \item{number_of_reviews_ltm}{The number of reviews the listing has (in the last 12 months).}
#'  \item{number_of_reviews_l30d}{The number of reviews the listing has (in the last 30 days).}
#'  \item{first_review}{The date of the first/oldest review.}
#'  \item{last_review}{The date of the last/newest review.}
#'  \item{review_scores_rating}{The review score for ratings of the listing.}
#'  \item{review_scores_accuracy}{The review score for accuracy of the listing.}
#'  \item{review_scores_cleanliness}{The review score for cleanliness of the listing.}
#'  \item{review_scores_checkin}{The review score for checkin experience of the listing.}
#'  \item{review_scores_communication}{The review score for communication of the listing.}
#'  \item{review_scores_location}{The review score for location of the listing.}
#'  \item{review_scores_value}{The review score for value of the listing.}
#'  \item{license}{The licence/permit/registration number.}
#'  \item{instant_bookable}{Whether the guest can automatically book the listing without the host requiring to accept their booking request. An indicator of a commercial listing.}
#'  \item{calculated_host_listings_count}{The number of listings the host has in the current scrape, in the city/region geography.}
#'  \item{calculated_host_listings_count_entire_homes}{The number of Entire home/apt listings the host has in the current scrape, in the city/region geography.}
#'  \item{calculated_host_listings_count_private_rooms}{The number of Private room listings the host has in the current scrape, in the city/region geography.}
#'  \item{calculated_host_listings_count_shared_rooms}{The number of Shared room listings the host has in the current scrape, in the city/region geography.}
#'  \item{reviews_per_month}{The average number of reviews per month the listing has over the lifetime of the listing.}
#' }
#'
#' @source https://insideairbnb.com/get-the-data/
"airbnb_listings"

#' @format ## `airbnb_reviews`
#' A data.frame with 5679 rows and 6 columns
#' \describe{
#'  \item{listing_id}{Unique identifier for the listing}
#'  \item{id}{Unique identifier for the review}
#'  \item{date}{Date of the review}
#'  \item{reviewer_id}{Unique identifier for the reviewer}
#'  \item{reviewer_name}{Name of the reviewer}
#'  \item{comments}{Text of the review}
#' }
#' @rdname airbnb_listings
"airbnb_reviews"

#' Amazon consumer reviews
#'
#' A sample of reviews from Amazon in the applicances category.
#' @format
#' A data.frame with 4549 rows and 11 columns
#' \describe{
#' \item{overall}{Overall rating of the product.}
#' \item{verified}{Whether the reviewer is verified or not.}
#' \item{review_date}{Review date.}
#' \item{review_id}{A unique identifier of the reviewer.}
#' \item{reviewer_name}{The name of the reviewer.}
#' \item{review_text}{The text of the review.}
#' \item{summary}{Summary of the review.}
#' \item{vote_helpful}{The number of helpful votes of the review.}
#' \item{image}{The images that the reviewer post after they receive the product.}
#' }
#' @source Jianmo Ni, Jiacheng Li, Julian McAuley (2019) Justifying recommendations using distantly-labeled reviews and fined-grained aspects. Empirical Methods in Natural Language Processing .
"consumer"

#' Hotel reviews
#'
#' A sample review of hotels.
#'
#' @format
#' A data.frame with 13,193 rows and 8 columns
#' \describe{
#' \item{reviewer_name}{The name of the reviewer.}
#' \item{reviewer_nationality}{The nationality of the reviewer.}
#' \item{reviewer_rating}{Reviewer's rating.}
#' \item{review_date}{Date of the review.}
#' \item{review_title}{Title of the review.}
#' \item{review_text}{Text of the review.}
#' \item{hotel_name}{Name of the hotel being reviewed.}
#' \item{avg_rating}{Average rating of the hotel.}
#' }
#' @source https://www.kaggle.com/datasets/nikitaryabukhin/reviewshotel
"hotel"

#' Review of Iori restaurant
#'
#' Iori is a Japanese restaurant in Canberra, Australia.
#' The data contains a sample of 20 reviews from Google maps.
#'
#' @format
#' A data.frame with 20 rows and 2 columns
#' \describe{
#'  \item{review}{The text of the review.}
#'  \item{rating}{A rating out of 5.}
#' }
#'
"restaurant"


#' Ask A Manager Salary Survey 2021
#'
#'
#' @format
#' A data.frame with 28,083 rows and 18 columns
#' \describe{
#'  \item{timestamp}{The timestampe of response.}
#'  \item{age}{Age cateogry. "How old are you?"}
#'  \item{industry}{Categorical but respondents can enter text for Other. "What industry do you work in?"}
#'  \item{job_title}{Text entry. "Job title"}
#'  \item{job_title_context}{Text entry. "If your job title needs additional context, please clarify here:"}
#'  \item{salary_annual}{Text entry. "What is your annual salary? (You'll indicate the currency in a later question. If you are part-time or hourly, please enter an annualized equivalent -- what you would earn if you worked the job 40 hours a week, 52 weeks a year.)"}
#'  \item{salarly_additional}{Text entry. "How much additional monetary compensation do you get, if any (for example, bonuses or overtime in an average year)? Please only include monetary compensation here, not the value of benefits."}
#'  \item{currency}{Categorical entry. "Please indicate the currency"}
#'  \item{currency_other}{Text entry. "If "Other," please indicate the currency here:"}
#'  \item{salary_context}{Text entry. "If your income needs additional context, please provide it here:"}
#'  \item{country}{Text entry. "What country do you work in?"}
#'  \item{state}{Categorical entry. "If you're in the U.S., what state do you work in?"}
#'  \item{city}{Text entry. "What city do you work in?"}
#'  \item{experience_overall}{Categorical entry. "How many years of professional work experience do you have overall?"}
#'  \item{experience_in_field}{Categorical entry. "How many years of professional work experience do you have in your field?"}
#'  \item{education}{Categorical entry."What is your highest level of education completed?"}
#'  \item{gender}{Categorical entry. "What is your gender?"}
#'  \item{race}{Multiselect entry. "What is your race? (Choose all that apply.)"}
#' }
#' @source https://www.askamanager.org/2021/04/how-much-money-do-you-make-4.html
"salary"

#' Recipes
#'
#' A sample of 200 recipes.
#' @format
#' A data.frame with 200 rows and 7 columns.
#' \describe{
#'  \item{name}{The name of the dish.}
#'  \item{ingredients}{The list of ingredients.}
#'  \item{url}{The URL of the recipe.}
#'  \item{image}{An image of the dish.}
#'  \item{cook_time}{Cooking time.}
#'  \item{prep_time}{Preperation time.}
#'  \item{servings}{The number of servings in text.}
#' }
#' @source https://github.com/jakevdp/open-recipe-data/tree/main
"recipes"


#' Alcohol warehouse adn retail sales
#'
#' \describe{
#' \item{year}{Year}
#' \item{month}{Month}
#' \item{supplier}{Supplier}
#' \item{item_code}{Item code}
#' \item{item_description}{Item description}
#' \item{item_type}{Item type}
#' \item{retail_sales}{Retail sales}
#' \item{retail_transfers}{Retail transfers}
#' \item{warehouse_sales}{Warehouse sales}
#' }
#'
#' @source https://catalog.data.gov/dataset/warehouse-and-retail-sales
"alcohol"
