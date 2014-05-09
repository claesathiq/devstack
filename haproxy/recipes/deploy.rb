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

version = haproxy-#{node.haproxy.version}-#{node.haproxy.tag}

# http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev24.tar.gz
filename = "#{version}.tar.gz"

install_dir = '~/install'

directory install_dir do
   owner "root"
   group "root"
   mode "0755"
   action :create
end

remote_file "#{install_dir}/#{filename}" do
   source "http://haproxy.1wt.eu/download/#{node.haproxy.version}/src/devel/#{filename}"
   #checksum "afe7d99201c2"
end

execute "untar-haproxy" do
  cwd install_dir
  command "tar --strip-components 1 -xzf " + filename
  creates "#{install_dir}/MAKEFILE"
end

execute "make" do
   cwd "install_dir/#{version}"
   command 'make TARGET="linux26" USE_STATIC_PCRE=1 USE_OPENSSL=1 && make install'
end

cookbook_file "/etc/init.d/haproxy" do
   source "haproxy.initd"
   owner "root"
   group "root"
   mode "0755"
end


user 'haproxy' do
   action :create
   system true
   comment "HAProxy User"
end

group "haproxy" do
   action :create
   members ['haproxy']
end

directory "/etc/haproxy" do
   owner "root"
   group "root"
   mode "0755"
   action :create
end

# Here we need to fifure out a way to get the real IP addresses of the instances
template "/etc/haproxy/haproxy.cfg" do
   source "haproxy.cfg.erb"
   owner "root"
   group "root"
   mode "0644"
   variables(
      domain => "#{node.haproxy.domain}",
      stats_title => "#{node.haproxy.stats_title}",
      admin_user => "#{node.haproxy.admin.user}",
      admin_password => "#{node.haproxy.admin.password}",
   )
end

# Set up dependecies between resources
service "haproxy" do
   supports :status => true, :restart => true, :start => true, :stop => true, :reload => true
   action [ :enable, :start ]
end
