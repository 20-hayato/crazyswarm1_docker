docker rm ros1_noetic

xhost +local:root
docker compose up --build -d
docker compose exec ros1_noetic bash