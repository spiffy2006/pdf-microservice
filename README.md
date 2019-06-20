# PDF Microservice

### Docker for development
1. Download docker here: https://www.docker.com/get-started
2. Once it is installed go to the project directory
3. Run `docker build -t pdf-microservice .` This will build the docker image.
4. Run `docker images` and it will list the image you just built
5. Run `docker run -d -p ${PORT_YOU_WANT}:80 -i -t ${IMAGE_ID}`

Now everything should be running and you can go to `localhost:${PORT_YOU_WANT}?url=https%3A%2F%2Fwww.google.com to interact with the api and get a pdf buffer of google's homepage

If you want to log into the docker container to do some bashjitsu:
1. Run `docker ps`
2. Run `docker exec -it ${CONTAINER_ID} /bin/bash`
3. Profit! You are in bash.

### Setup for actual server
1. Run `apt-get update && apt-get install -y software-properties-common`
2. Run `curl -sL https://deb.nodesource.com/setup_12.x | bash -`
3. Run `wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -`
4. Run `echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list`
5. Run `apt-get update && apt-get install -y gnupg apt-transport-https ca-certificates nodejs libapache2-mod-passenger google-chrome-stable`
6. Run `apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7`
7. Run `sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list'`
8. Create file in `/etc/apache2/sites-available/pdf-microservices.conf`
~~~~
<VirtualHost *:80>
    ServerName pdf.stage.api-microservices.ddm.io
    # Tell Apache and Passenger where your app's code directory is
    DocumentRoot /var/www/pdf-microservice/api
    PassengerAppRoot /var/www/pdf-microservice/api
    # Tell Passenger that your app is a Node.js app
    PassengerAppType node
    PassengerStartupFile index.js
    # Relax Apache security settings
    <Directory /var/www/pdf-microservice>
      Allow from all
      Options -MultiViews
      # Uncomment this if you're on Apache >= 2.4:
      Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/pdf-microservice.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
~~~~
9. Run `a2enmod passenger`
10. Run `apache2ctl restart`
11. Run `/usr/bin/passenger-config validate-install` on passenger itself
12. Run `a2ensite pdf-microservices.conf`
13. Make sure that the subdomain can get traffic.
