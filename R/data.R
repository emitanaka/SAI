
#' Airbnb listings and reviews
#'
#' A sample dataset of Airbnb listings and reviews
#' of properties from Sydney, Australia.
#'
#' @format ## `airbnb_listings`
#' A data.frame with 1623 rows and 68 columns
#' \describe{
#'  \item{id}{Unique identifier for the listing}
#'  \item{name}{Name of the listing}
#'  \item{host_id}{Unique identifier for the host}
#'  \item{host_name}{Name of the host}
#'  \item{neighbourhood_group_cleansed}{Neighbourhood group}
#'  \item{neighbourhood_cleansed}{Neighbourhood}
#'  \item{latitude}{Latitude of the listing}
#'  \item{longitude}{Longitude of the listing}
#'  \item{room_type}{Type of room}
#'  \item{price}{Price per night}
#'  \item{minimum_nights}{Minimum nights required}
#'  \item{maximum_nights}{Maximum nights allowed}
#'  \item{availability_30}{Number of days available in the next 30 days}
#'  \item{availability_60}{Number of days available in the next 60 days}
#'  \item{availability_90}{Number of days available in the next 90 days}
#'  \item{availability_365}{Number of days available in the next 365 days}
#'  \item{number_of_reviews}{Number of reviews}
#'  \item{number_of_reviews_ltm}{Number of reviews in the last 12 months}
#'  \item{first_review}{Date of the first review}
#'  \item{last_review}{Date of the last review}
#'  \item{review_scores_rating}{Rating score}
#'  \item{review_scores_accuracy}{Accuracy score}
#'  \item{review_scores_cleanliness}{Cleanliness score}
#'  \item{review_scores_checkin}{Check-in score}
#'  \item{review_scores_communication}{Communication score}
#'  \item{review_scores_location}{Location score}
#'  \item{review_scores_value}{Value score}
#'  \item{instant_bookable}{Instant booking available}
#'  \item{calculated_host_listings_count}{Number of listings by the host}
#'  \item{calculated_host_listings_count_entire_homes}{Number of entire homes by the host}
#'  \item{calculated_host_listings_count_private_rooms}{Number of private rooms by the host}
#'  \item{calculated_host_listings_count_shared_rooms}{Number of shared rooms by the host}
#'  \item{reviews_per_month}{Number of reviews per month}
#'  \item{host_is_superhost}{Host is a superhost}
#'  \item{host_has_profile_pic}{Host has a profile picture}
#'  \item{host_identity_verified}{Host identity is verified}
#'  \item{host_response_time}{Host response time}
#'  \item{host_response_rate}{Host response rate}
#'  \item{host_acceptance_rate}{Host acceptance rate}
#'  \item{host_neighbourhood}{Host neighbourhood}
#'  \item{host_listings_count}{Number of listings by the host}
#'  \item{host_total_listings_count}{Total number of listings by the host}
#'  \item{host_verifications}{Host verifications}
#'  \item{host_has_profile_pic}{Host has a profile picture}
#'  \item{host_identity_verified}{Host identity is verified}
#'  \item{neighbourhood}{Neighbourhood}
#'  \item{neighbourhood_cleansed}{Neighbourhood}
#'  \item{neighbourhood_group_cleansed}{Neighbourhood group}
#'  \item{city}{City}
#'  \item{state}{State}
#'  \item{zipcode}{Zipcode}
#'  \item{market}{Market}
#'  \item{smart_location}{Smart location}
#'  \item{country_code}{Country code}
#'  \item{country}{Country}
#'  \item{latitude}{Latitude}
#'  \item{longitude}{Longitude}
#'  \item{is_location_exact}{Location is exact}
#'  \item{property_type}{Property type}
#'  \item{room_type}{Room type}
#'  \item{accommodates}{Number of guests accommodated}
#'  \item{bathrooms}{Number of bathrooms}
#'  \item{bedrooms}{Number of bedrooms}
#'  \item{beds}{Number of beds}
#'  \item{bed_type}{Type of bed}
#'  \item{amenities}{Amenities}
#'  \item{square_feet}{Square feet}
#'  \item{price}{Price per night}
#'  \item{weekly_price}{Weekly price}
#'  \item{monthly_price}{Monthly price}
#'  \item{security_deposit}{Security deposit}
#'  \item{cleaning_fee}{Cleaning fee}s
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
"consumer"

#' Hotel reviews
#'
"hotel"
