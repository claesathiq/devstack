haproxy Cookbook
===============
This cookbook installs HAProxy


Certificates
------------

# If using this for git, and using a self-signed certificate,
# download the certificate to a suitable directory and issue
# Make sure only the certificate is containedin the file, no keys

git config --global http.sslCAInfo /<path to pem>/certificate.pem


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
