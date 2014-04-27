default["gitlab"]["version"]               = "6.8.1"
default["gitlab"]["omnibus"]["version"]    = "4-1"
default["gitlab"]["installer"]["md5"]      = "93eb68aa407a33f01b376308bde0b465"
default["gitlab"]["installer"]["checksum"] = "afe7d99201c2"   # "afe7d99201c29ea901517a3df8daa9d54948282c71360df02499dabdd390636d"

# for your local machine, add the ip address of the VM in the host file, e.g.
# 192.168.3.10   gitlab.islocal.com
default['gitlab']['domain']              = 'isassaabloy.com'
default['gitlab']['hostname']            = 'git'