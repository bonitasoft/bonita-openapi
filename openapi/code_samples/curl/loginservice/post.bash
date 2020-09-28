# Generate cookie file
curl -X POST -vvv -c saved_cookies.txt -o /dev/null \
--url 'http://localhost:8080/bonita/loginservice' \
--header 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' \
-d 'username=install&password=install&redirect=false&redirectURL=/'

# Reuse the cookie file
curl -b saved_cookies.txt -X GET \
--url 'http://localhost:8080/bonita/API/bpm/process?c=100&p=0'