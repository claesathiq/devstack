docker-reg Cookbook
===============
This cookbook installs a docker registry

It really down nothing but calls OpsCode's docker-registry recipe


Usage
-----
#### docker-reg::default
Add roles:

chef.add_role("docker-registry_application_server")
chef.add_role("docker-registry_load_balancer")
chef.add_role("docker-registry")

Include `docker-reg` in your node's `run_list`:


```json
{
  "run_list": ["recipe[docker-reg::default]"],
  "docker-registry": {
  	  "revision": "",
      "server_name": "docker.localhost.com",
      "secret-key": "fksldjriohl2kfsn2lh342kjfdeaslhkhfskjnhalknfk4232snfkldjfsdf3242"
  }
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com
