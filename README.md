# curly-meme
A simple rust hello-world using warp, on push to this repo github actions will lint, test, and build a binary. This is uploaded to github artifacts once uploaded a docker container is created and pushed to ghcr.io.

AWS ECS Fargate cluster is spun up via terraform (state is stored localy). Once the terraform has done its thing you should be able to hit the loadbalancer to see `Hello, World! -bab`

test build 20240429
