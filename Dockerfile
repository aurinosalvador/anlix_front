# Image to use
FROM nginx:alpine

# in this step github actions build is finished, then copy files to nginx
COPY ./build/web/ /usr/share/nginx/html/

