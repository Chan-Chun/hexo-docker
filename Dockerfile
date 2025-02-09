# 使用 Ubuntu 作为基础镜像
FROM ubuntu:latest

# 设置环境变量（避免交互式提示）
ENV DEBIAN_FRONTEND=noninteractive

# 替换为国内镜像源
RUN sed -i 's#http://deb.debian.org#https://mirrors.163.com#g' /etc/apt/sources.list && \
  sed -i 's#http://security.debian.org#https://mirrors.163.com#g' /etc/apt/sources.list && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get update

# 安装必要的软件
RUN apt-get install -y git openssh-server nginx cron certbot python3-certbot-nginx

# 创建 nginx 用户
RUN useradd -r -s /usr/sbin/nologin nginx

# 初始化 Git 裸仓库（路径保持不变）
RUN git init --bare /root/blogs.git

# 创建目标目录
RUN mkdir -p /var/www/hexo

# 配置 post-receive 钩子
RUN echo "#!/bin/sh" > /root/blogs.git/hooks/post-receive && \
  echo "git --work-tree=/var/www/hexo --git-dir=/root/blogs.git checkout -f" >> /root/blogs.git/hooks/post-receive && \
  chmod +x /root/blogs.git/hooks/post-receive

# 初始化仓库并创建初始提交（解决 bad object 问题）
RUN git clone /root/blogs.git /tmp/blogs && \
  cd /tmp/blogs && \
  echo "Initial commit" > README.md && \
  git add README.md && \
  git config --global user.email "you@example.com" && \
  git config --global user.name "Your Name" && \
  git commit -m "Initial commit" && \
  git push origin master && \
  cd / && \
  rm -rf /tmp/blogs

# 配置 SSH 服务（仅生成主机密钥，不限制登录形式）
RUN rm -f /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key && \
  ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
  ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && \
  ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

# 添加 Nginx 配置文件
ADD nginx/hexo.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 22
EXPOSE 80
EXPOSE 443

# 启动 SSH 和 Nginx 服务
CMD service ssh start && nginx -g "daemon off;"