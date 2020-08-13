FROM centos:7
COPY . /usr/local/node
RUN \
  yum install -y wget && \
  mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
  yum makecache && \
  yum update -y && \
  yum install -y epel-release && \
  yum install -y nginx && \
  yum install -y git && \
  yum install -y vim && \
  git init --bare ~/blogs.git && \
  echo "git --work-tree=/usr/share/nginx/html --git-dir=/root/blogs.git checkout -f" >~/blogs.git/hooks/post-receive && \
  chmod a+x ~/blogs.git/hooks/post-receive && \
  yum install -y openssh openssh-server openssh-clients && \
  ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
  ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
  ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
EXPOSE 22
EXPOSE 80
CMD ["nginx","-g","daemon off;"]