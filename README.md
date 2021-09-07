# hexo-docker

[Docker Hub](https://hub.docker.com/r/chanchun/hexo-docker)

## Build
```shell
docker build -t hexo-docker .
```

> My docker hub tag ` docker tag hexo-docker:latest chanchun/hexo-docker:latest`

## Run

```shell
docker run -v $(pwd)/letsencrypt:/etc/letsencrypt -d -p 80:80 -p 443:443 -p 8004:22 hexo-docker
```

## Setting

First enter docker container

```shell
docker exec -it "[your_container_name]" /bin/bash
```

### Let’s Encypt Setting

Creat certificate

```shell
certbot --nginx -d "[your_domain.com]"
```

Renew the certificate when it is about to expire

```shell
/usr/bin/certbot renew
```

### Hexo Setting

```shell
mkdir ~/.ssh
```

```shell
echo "[your_ssh_public_key]" > ~/.ssh/authorized_keys
```

```shell
chmod 600 ~/.ssh/authorized_keys
```

```shell
chmod 700 ~/.ssh
```

```shell
mkdir /run/sshd
```

```shell
/usr/sbin/sshd
```

## Hexo Deploy

Hexo `_config.yml` 

```yaml
deploy:
  type: git
  repo: root@hexo-test:/root/blogs.git
  branch: master
```

`.ssh/config`

```
Host hexo-test
  HostName [your_remote_server_ip]
  Port 8004
```



