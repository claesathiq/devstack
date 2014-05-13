haproxy Cookbook
===============
This cookbook installs HAProxy


Certificates
------------

If using this for git, and using a self-signed certificate,
download the certificate to a suitable directory and issue
Make sure only the certificate is containedin the file, no keys

	git config --global http.sslCAInfo /<path to pem>/certificate.pem


Install procedure
-----------------

	apt-get build-dep -y haproxy  
	apt-get install -y libssl-dev  
	wget http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev24.tar.gz  
	tar xzvf haproxy-1.5-dev24.tar.gz  
	cd haproxy-1.5-dev24/  
	make TARGET="linux26" USE_STATIC_PCRE=1 USE_OPENSSL=1  
	make install

We have our own init.d file; copy haproxy.initd => /etc/init.d/haproxy
Taken from `curl https://gist.github.com/luhn/9038945/raw/haproxy.initd > /etc/init.d/haproxy`  

	chmod +x /etc/init.d/haproxy  
	mkdir /etc/haproxy  
	update-rc.d haproxy defaults  
	adduser --system haproxy  
	groupadd haproxy  
	usermod -G haproxy haproxy  


	update-rc.d haproxy defaults



Health checks
-------------

Currently no health chekcs are configured, but when/if they are, it could look like this

	backend git :80
		option httpchk /haproxy_health_check
		server git-server 10.0.1.83:80 check inter 5000 fastinter 1000 fall 1 weight 1


Serf
----

Eventually Serf will be used to manage the cluster

A simple script will be developed that adds/rmoves something like this from /etc/haproxy/haproxy.cfg

	backend ${NODE_ROLE} :80
    	server ${NODE_ROLE}-server ${NODE_IP}:80

then issues

	service haproxy reload


Usage
-----
#### haproxy::default
Just include `haproxy` in your node's `run_list`:



```json
{
	"run_list": ["recipe[haproxy::default]"]
  	"haproxy": {
    	"domain": "localhost.com"
  	}
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com
