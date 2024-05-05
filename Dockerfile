FROM docker/compose:latest

COPY docker-compose.yml /path/to/your/docker-compose.yml

CMD ["docker-compose", "up"]
