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
