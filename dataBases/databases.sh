#after installing mac desktop client

docker pull postgres
mkdir -p $HOME/docker/volumes/postgres
docker run --rm   --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data  postgres



docker exec -it pg-docker psql -U postgres -c "create database govtech"

pip3 install psycopg2-binary
