
default['haproxy']['version']           = "1.5"
default['haproxy']['tag']               = "dev24"
default['haproxy']['file']['checksum']  = "430ca2998c894d214b4b0a6ca083ed0159836b2fd6b2de1075454ca21e32227a"

default['haproxy']['domain']			= "st.assaabloy.net"

default['haproxy']['stats_title']		= "Shared\\ Tech\\ Haproxy\\ Statistics"

# Should be in an enrcypted data bag
default['haproxy']['admin']['user']		= "admin"
default['haproxy']['admin']['password']	= "argus2014"
