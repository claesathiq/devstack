ec2-hostname Cookbook
===============
This cookbook sets a FQDN in an EC2 instance


Usage
-----
#### ec2-hostname::default
Just include `ec2-hostname` in your node's `run_list`:

When launching the EC2 instance, set the hostname as userdata, for instance "jira"


```json
{
	"run_list": ["recipe[ec2-hostname::default]"],
  	"ec2-hostname": {
    	"domain": "sharedtech.net"
  	}
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com
