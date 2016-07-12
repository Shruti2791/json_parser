#The program converts a json string into a json object

require_relative '../lib/json'

json_string = '[{"state": {"cities": ["Mumbai", "Pune", "Nagpur", "Bhusaval", "Jalgaon"], "name": "Maharashtra"}}, {"state": {"cities": ["Bangalore", "Hubli"], "name": "Karnataka"}}, {"state": {"states": ["Raipur", "Durg"], "name": "Chhattisgarh"}}]'

json = Json.new(json_string)
p json.parse