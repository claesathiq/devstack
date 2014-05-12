#
# Cookbook Name:: haproxy
# Recipe:: deploy
#
# Copyright 2014, ASSA ABLOY AB
#
# All rights reserved - Do Not Redistribute
#

execute "haproxy_build_deps" do
   command "apt-get build-dep -y haproxy"
   action :run
end

package 'libssl-dev' do
	action :install
end

version = "haproxy-#{node.haproxy.version}-#{node.haproxy.tag}"

# http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev24.tar.gz
filename = "#{version}.tar.gz"

install_dir = Chef::Config[:file_cache_path] + '/install'

directory install_dir do
   owner "root"
   group "root"
   mode "0755"
   action :create
end

remote_checksum = node.haproxy.file.checksum

remote_file "#{install_dir}/#{filename}" do
   source "http://haproxy.1wt.eu/download/#{node.haproxy.version}/src/devel/#{filename}"
   checksum remote_checksum
   notifies :create, "ruby_block[calc-remote-checksum]", :immediately
end


ruby_block "calc-remote-checksum" do
  action :nothing
  block do
    require 'digest'
    remote_checksum = Digest::SHA256.file("#{install_dir}/#{filename}").hexdigest
    #override['haproxy']['file']['checksum'] = remote_checksum
    node.override_attrs[:haproxy][:file][:checksum] = remote_checksum
    puts("Checksum: " + remote_checksum)
  end
  notifies :run, "execute[untar-haproxy]", :immediately
end


execute "untar-haproxy" do
  cwd install_dir
  command "tar -xzf " + filename
  action :run
  # creates "#{install_dir}/MAKEFILE"
    notifies :run, "execute[make-haproxy]", :immediately
end

execute "make-haproxy" do
   cwd "#{install_dir}/#{version}"
   command 'make TARGET="linux26" USE_STATIC_PCRE=1 USE_OPENSSL=1 && make install'
   action :nothing
   notifies :restart, "service[haproxy]", :delayed
end

cookbook_file "/etc/init.d/haproxy" do
   source "haproxy.initd"
   owner "root"
   group "root"
   mode "0755"
end

cookbook_file "/etc/ssl/certs/wildcard.#{node.haproxy.domain}.pem" do
   source "wildcard.#{node.haproxy.domain}.pem"
   owner "root"
   group "root"
   mode "0644"
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

service "haproxy" do
   supports :status => true, :restart => true, :start => true, :stop => true, :reload => true
   action :nothing
end

# Here we need to figure out a way to get the real IP addresses of the instances
template "/etc/haproxy/haproxy.cfg" do
   source "haproxy.cfg.erb"
   owner "root"
   group "root"
   mode "0644"
   variables(
      :domain         => "#{node.haproxy.domain}",
      :stats_title    => "#{node.haproxy.stats_title}",
      :admin_user     => "#{node.haproxy.admin.user}",
      :admin_password => "#{node.haproxy.admin.password}",
   )
   notifies :enable, "service[haproxy]"
   notifies :start, "service[haproxy]"
end
