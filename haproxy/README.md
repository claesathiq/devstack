haproxy Cookbook
===============
This cookbook installs HAProxy


Certificates
------------

# If using this for git, and using a self-signed certificate,
# download the certificate to a suitable directory and issue
# Make sure only the certificate is containedin the file, no keys

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

# We have our own init.d file; copy haproxy.initd => /etc/init.d/haproxy
## curl https://gist.github.com/luhn/9038945/raw/haproxy.initd > /etc/init.d/haproxy  

chmod +x /etc/init.d/haproxy  
mkdir /etc/haproxy  
update-rc.d haproxy defaults  
adduser --system haproxy  
groupadd haproxy  
usermod -G haproxy haproxy  

# We have our own haproxy.cfg template; template haproxy.cfg.erb => /etc/haproxy/haproxy.cfg
## curl https://gist.github.com/luhn/9038945/raw/haproxy.sample.cfg > /etc/haproxy/haproxy.cfg  

update-rc.d haproxy defaults


Install procedure
-----------------

apt-get build-dep -y haproxy  
apt-get install -y libssl-dev  
wget http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev24.tar.gz  
tar xzvf haproxy-1.5-dev24.tar.gz  
cd haproxy-1.5-dev24/  
make TARGET="linux26" USE_STATIC_PCRE=1 USE_OPENSSL=1  
make install

# We have our own init.d file; copy haproxy.initd => /etc/init.d/haproxy
## curl https://gist.github.com/luhn/9038945/raw/haproxy.initd > /etc/init.d/haproxy  

chmod +x /etc/init.d/haproxy  
mkdir /etc/haproxy  
update-rc.d haproxy defaults  
adduser --system haproxy  
groupadd haproxy  
usermod -G haproxy haproxy  

# We have our own haproxy.cfg template; template haproxy.cfg.erb => /etc/haproxy/haproxy.cfg
## curl https://gist.github.com/luhn/9038945/raw/haproxy.sample.cfg > /etc/haproxy/haproxy.cfg  

update-rc.d haproxy defaults


Usage
-----
#### haproxy::default
Just include `haproxy` in your node's `run_list`:



```json
{
	"run_list": ["recipe[haproxy::default]"],
  	"haproxy": {
    	"setting": "value"
  	}
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com
