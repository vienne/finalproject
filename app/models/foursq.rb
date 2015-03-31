require 'httparty'

var baseURL = "https://api.foursquare.com/v2/venues/search"

var version = "&v=20150223";


 		name: venue["name"],
    website: venue["url"],
    checkins: venue["stats"]["checkinsCount"],
    users: venue["stats"]["usersCount"],
    usersHereNow: venue["hereNow"]["count"],
    hereNowSummary: venue["hereNow"]["summary"]

    https://api.foursquare.com/v2/venues/search
  ?client_id=CLIENT_ID
  &client_secret=CLIENT_SECRET
  &v=20130815
  &ll=40.7,-74
  &query=sushi

