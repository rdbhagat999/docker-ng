#  build stage
# This line will tell the docker to pull the node image with tag 12.6.1-alpine if the images don't exist. 
# We are also giving a friendly name build to this image so we can refer it later.
FROM node:14-buster-slim AS builder

# This WORKDIR command will create the working directory in our docker image. 
# Going forward any command will be run in the context of this directory.
WORKDIR /app

# This COPY command copies all the files from our current directory to the container working directory. this will copy all our source files.
COPY . .

# This RUN command will restore node_modules define in our package-lock.json
RUN npm ci && npm run build -- --prod

# runtime stage
# This line will create a second stage nginx container where we will copy the compiled output from our build stage.
FROM nginx:1.19.6-alpine

EXPOSE 80

# This is the final command of our docker file. 
# This will copy the compiled angular app from build stage path /app/dist/docker-ng/ to nginx container.
COPY --from=builder /app/dist/docker-ng/ /usr/share/nginx/html
