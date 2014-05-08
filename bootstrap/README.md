bootstrap Cookbook
===============
This cookbook bootstraps an EC2 instance


Usage
-----
#### bootstrap::default
Just include `bootstrap` in your node's `run_list`:

When launching the EC2 instance, set the hostname as userdata, for instance "jira"


```json
{
	"run_list": ["recipe[bootstrap::default]"],
  	"bootstrap": {
    	"domain": "sharedtech.net"
  	}
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com
