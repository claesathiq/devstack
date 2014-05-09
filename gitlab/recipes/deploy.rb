#
# Cookbook Name:: gitlab
# Recipe:: deploy
#
# Copyright 2014, BBSC
#
# All rights reserved - Do Not Redistribute
#

filename = "gitlab_#{node.gitlab.version}-omnibus.#{node.gitlab.omnibus.version}_amd64.deb"

gitlab_package = Chef::Config[:file_cache_path] + "/#{filename}"

remote_file gitlab_package do
   source "https://downloads-packages.s3.amazonaws.com/ubuntu-12.04/#{filename}"
   checksum "afe7d99201c2"
end

dpkg_package 'gitlab' do
   source gitlab_package
   version "#{node.gitlab.version}-omnibus.#{node.gitlab.omnibus.version}"
   # checksum "afe7d99201c2"
   # checksum "afe7d99201c29ea901517a3df8daa9d54948282c71360df02499dabdd390636d"
   action :install
end

directory "/etc/gitlab" do
	owner "root"
	group "root"
	mode "0755"
	action :nothing
	subscribes :create, resources(:dpkg_package => "gitlab"), :immediately
end

# Make sure FQDN is set before running this
template '/etc/gitlab/gitlab.rb' do
	source 'gitlab.erb'
	mode 0644
	variables(
		:gitlab_host  => "#{node.gitlab.hostname}.#{node.gitlab.domain}",
		:gitlab_data_dir  => "#{node.gitlab.data_dir}"
	)
	action :nothing
	subscribes :create, resources(:directory => "/etc/gitlab"), :immediately
end


execute 'gitlab-reconfig' do
	command "gitlab-ctl reconfigure"
	action :nothing
	subscribes :run, resources(:template => '/etc/gitlab/gitlab.rb'), :delayed
end
