# nginx_proxy_docker
An nginx proxy support https based on docker

# clone this repositories 
git clone https://github.com/wll-zhou/nginx_proxy_docker.git

# build image
 docker build -t nginx:proxy_1.17.4 .
 
# run it
docker run -d -p 8888:8888 -v /path/to/nginx_proxy_docker/nginx.conf:/etc/nginx/nginx.conf nginx:proxy_1.17.4

# test it
curl https://www.geek-share.com -v -x 127.0.0.1:8888
