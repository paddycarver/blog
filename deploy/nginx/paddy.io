server {
	listen 80;
	listen [::]:80;
	server_name paddy.io;

	location = /posts/feed.xml {
		return 301 https://paddy.carvers.co/posts/index.xml;
	}

	location = /feeds/posts/default {
		return 301 https://paddy.carvers.co/posts/index.xml;
	}

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://paddy.carvers.co$request_uri;
	}

	if ($http_x_forwarded_proto = "http") {
		return 301 https://paddy.carvers.co$request_uri;
	}
}

server {
	listen 80;
	listen [::]:80;
	server_name drafts.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://drafts.paddy.carvers.co$request_uri;
	}

	if ($http_x_forwarded_proto = "http") {
		return 301 https://drafts.paddy.carvers.co$request_uri;
	}
}

server {
	listen 80;
	listen [::]:80;

	server_name www.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://paddy.carvers.co$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}

server {
	listen 80;
	listen [::]:80;

	server_name www.drafts.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://drafts.paddy.carvers.co$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}

server {
	listen 80;
	listen [::]:80;

	server_name www.gifs.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://gifs.paddy.io$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}

server {
	listen 80;
	listen [::]:80;

	server_name www.static.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://static.paddy.io$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}

server {
	listen 80;
	listen [::]:80;

	server_name www.talks.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://talks.paddy.io$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}

server {
	listen 80;
	listen [::]:80;

	server_name www.usmc.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://usmc.paddy.io$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}

server {
	listen 80;
	listen [::]:80;

	server_name www.mom.paddy.io;

	location / {
		expires max;
		add_header Cache-Control "public";
		return 301 https://mom.paddy.io$request_uri;
	}

	location /health {
		expires -1;
		add_header Content-Type text/plain;
		return 200 'OK';
	}
}
