#!/bin/sh
set -ex
export

# Run container(s)
docker-compose up --build -d
docker ps
sleep 10 # give a bit of time to turn the state
[ "$(docker inspect -f '{{ .State.Running }}' docker_ldap_1)"   = "true" ] || exit 1
[ "$(docker inspect -f '{{ .State.Running }}' docker_gerrit_1)" = "true" ] || exit 1

# Wait until gerrit become ready
# Dont check the ldap as assume it is faster to start
expect -c '
spawn docker logs -f docker_gerrit_1
set timeout 180
expect {
    " ready" { exit 0 }
    timeout  { exit 1 }
}
'

# Check gerrit works
curl -f -v -X GET localhost:8080/
# Initial login as admin - it will create admin account in yet empty gerrit
curl -f -v -d "username=admin1&password=password" -H "Content-Type: application/x-www-form-urlencoded" -X POST localhost:8080/login/
# Check the admin account
curl -f -v -X GET -u admin1:password localhost:8080/a/accounts/self

# Now we are all setup!
echo "Done!"
