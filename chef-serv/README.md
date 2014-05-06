cher-serv Cookbook
===============
This cookbook installs Chef Server on Amazon OpsWorks using the Omnibus installer

It really down nothing but calls OpsCode's chef-server recipe

Default account
---------------
On first install, the default login is:
user: admin
password: p@ssw0rd1

Usage
-----
#### chef-serv::default
Just include `chef-serv` in your node's `run_list`:



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
