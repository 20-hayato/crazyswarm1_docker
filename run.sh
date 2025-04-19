docker rm ros1_noetic

docker compose up --build -d
docker compose exec ros1_noetic bash