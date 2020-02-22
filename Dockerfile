FROM python:3.8.1-alpine

MAINTAINER yuban10703 "2846021566@qq.com"  

ENV LIBRARY_PATH=/lib:/usr/lib

WORKDIR /app

RUN apk add --no-cache --virtual bianyi git gcc build-base libffi-dev && \
	git clone https://github.com/yjqiang/YjMonitor /app && \
	pip install aiohttp==3.6.2 aiojobs==0.2.2 argon2-cffi==19.2.0 async-timeout==3.0.1 attrs==19.3.0 cffi==1.14.0 multidict==4.7.4 pampy==0.3.0 pyasn1==0.4.8 pycparser==2.19 rsa==4.0 toml==0.10.0 yarl==1.4.2 requests==2.21.0 idna==2.6 && \
	python ctrl/key/create_key.py && \
	mv pubkey.pem ctrl/key/admin_pubkey.pem && \
	mv privkey.pem ctrl/key/admin_privkey.pem && \
	cp ctrl/key/*.pem server/key && \
	cp ctrl/key/*.pem monitor/key && \
	python ctrl/key/create_key.py && \
	mv pubkey.pem ctrl/key/super_admin_pubkey.pem && \
	mv privkey.pem ctrl/key/super_admin_privkey.pem && \
	cp ctrl/key/*.pem server/key && \
	cp ctrl/key/*.pem monitor/key && \
	sed -i 's/192.168.0.107/127.0.0.1/g' ctrl/global_var.py && \
	sed -i 's/max_users = 1/max_users = 9999/g' ctrl/req_create_key.py && \
	(python /app/server/run.py&python /app/ctrl/req_create_key.py)>key && \	
	apk del bianyi && \
	apk add --no-cache git
CMD sed -n '/JSON/,$p' /app/key&&git pull&&(python server/run.py&python monitor/run.py)