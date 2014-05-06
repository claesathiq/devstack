haproxy Cookbook
===============
This cookbook installs HAProxy



Usage
-----
#### haproxy::default
Just include `haproxy` in your node's `run_list`:



```json
{
	"run_list": ["recipe[haproxy::default]"],
  	"chef-server": {
    	"api_fqdn": "chef.localhost.com"
    	"nginx": {
    		"enable_non_ssl": "true"
  		}
  	}
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com
