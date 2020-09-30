# Generate cookie file
curl -v -c saved_cookies.txt \
--url 'http://localhost:8080/bonita/loginservice' \
--header 'Content-Type: application/x-www-form-urlencoded'
--data-urlencode 'username=install' \
--data-urlencode 'password=install' \
--data-urlencode 'redirect=false' \
--data-urlencode 'redirectURL=' 



# Reuse the cookie file and set the `X-Bonita-API-Token` header
curl -b saved_cookies.txt -X GET \
-- header 'X-Bonita-API-Token: <token>' \
--url 'http://localhost:8080/bonita/API/bpm/process?c=100&p=0'