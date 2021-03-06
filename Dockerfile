FROM debian:buster

# RUN apt-get update && sudo apt-get upgrade -y \
#  && apt-get install nginx \
#     nodejs \
#     npm \
RUN apt-get update && apt-get install -y curl software-properties-common wget
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y apache2 \
    dirmngr \
    gnupg \
    apt-transport-https \
    ca-certificates \
    nodejs \
    libapache2-mod-passenger \
    vim \
    google-chrome-stable \
 && apt-get clean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

# RUN apt install -y ./google-chrome-stable_current_amd64.deb
# RUN apt --fix-broken install
WORKDIR /var/www/marketplace-url-to-pdf
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list'

# COPY ./api /var/www/marketplace-url-to-pdf/api/
COPY package*.json ./
RUN npm install
COPY . .

# Copy over the apache configuration file and enable the site
COPY ./conf/marketplace-url-to-pdf.conf /etc/apache2/sites-available/marketplace-url-to-pdf.conf
RUN a2enmod passenger
RUN apache2ctl restart
RUN /usr/bin/passenger-config validate-install

RUN a2dissite 000-default.conf
RUN a2ensite marketplace-url-to-pdf.conf

EXPOSE 80

# CMD ["/bin/bash"]
CMD  /usr/sbin/apache2ctl -D FOREGROUND