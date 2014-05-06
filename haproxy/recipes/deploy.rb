#
# Cookbook Name:: chef-serv
# Recipe:: deploy
#
# Copyright 2014, ASSA ABLOY AB
#
# All rights reserved - Do Not Redistribute
#

w"build-dep haproxy libssl-dev".each |pkg| do
	package pkg do
		action :install
	end
end
	
# http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev24.tar.gz
filename = "haproxy-#{node.haproxy.version}-#{node.haproxy.tag}.tar.gz"

haproxy_package = Chef::Config[:file_cache_path] + "/#{filename}"

remote_file haproxy_package do
   source "http://haproxy.1wt.eu/download/#{node.haproxy.version}/src/devel/#{filename}"
   #checksum "afe7d99201c2"
end

dpkg_package 'haproxy' do
   source haproxy_package
   version "#{node.haproxy.version}-#{node.haproxy.tag}"
   # checksum "afe7d99201c2"
   # checksum "afe7d99201c29ea901517a3df8daa9d54948282c71360df02499dabdd390636d"
   action :install
end

