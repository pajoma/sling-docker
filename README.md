# sling-docker
Docker image for SLING

`docker build -t sling .`

`docker run -t sling`


## Run with docker-compose
`docker-compose build` to build the image (takes a while, since sling is compiling)

`docker-compose run sling bash` to switch to console within the container


## Build Wikipedia

Adapt mounts in docker-compose if needed (lots of diskspace required)

Run `docker-compose run sling bash` (after building the image), and execute the following scripts 
following https://github.com/google/sling/blob/caspar/doc/guide/wikiflow.md


