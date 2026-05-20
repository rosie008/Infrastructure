#!/bin/bash

apt update -y
apt install nginx -y

cat > /etc/nginx/conf.d/loadbalancer.conf <<EOF
upstream backend {
    server ${backend_1};
    server ${backend_2};
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

systemctl enable nginx
systemctl restart nginx