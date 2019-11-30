server {
	listen 80;
	listen [::]:80;


	server_name paddyforan.com www.paddyforan.com;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://paddy.io$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}
