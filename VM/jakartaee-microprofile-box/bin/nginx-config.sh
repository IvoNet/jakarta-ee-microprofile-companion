#!/bin/sh
# Remove config if already exists
rm -fv /etc/nginx/sites-enabled/* 2>/dev/null

# Retrieve the DASHBOARD IP
DASH_IP=$(kubectl get services --all-namespaces|grep kubernetes-dashboard| awk '{print $4}')

# Retrieve the secret TOKEN for Bearer
default_token=$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
TOKEN=$(microk8s.kubectl -n kube-system describe secret ${default_token} | grep token: | awk '{print $2}')

# Retrieve admin password
password="$(microk8s.kubectl config view|grep password:|awk '{print $2}')"

# Encode it to base64 for Basic authentication
BASE_AUTH=$(python3 -c "import base64; print(\"%s\" % str(base64.encodebytes(b\"admin:${password}\"),\"utf-8\").strip().replace(\"\n\",\"\"))")

# Get Graphana IP
GRAPHANA_IP=$(kubectl get services --all-namespaces|grep monitoring-grafana| awk '{print $4}')


# Create the kubernetes config
cat <<EOF >/etc/nginx/sites-available/kubernetes.conf
#!/bin/sh
server {
    listen 80;
    location / {
        proxy_set_header Authorization "Basic ${BASE_AUTH}";
        proxy_pass https://192.168.10.100:16443/;
    }

    location /dash/ {
        proxy_set_header  Authorization "Bearer ${TOKEN}";
        proxy_pass https://${DASH_IP}/;
    }
    location /graphana/ {
        proxy_pass http://${GRAPHANA_IP}/;
    }
}
EOF

# Create the enabled config
ln -s /etc/nginx/sites-available/kubernetes.conf /etc/nginx/sites-enabled/kubernetes.conf
service nginx restart
