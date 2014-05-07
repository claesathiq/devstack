#
# Cookbook Name:: gitlab
# Recipe:: setup
#
# Copyright 2014, BBSC
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt::default"


execute "set-hostname-postfix" do
	command "debconf-set-selections <<< \"postfix postfix/mailname string #{node.gitlab.hostname}\""
	action :run
end

execute "set-isite-postfix" do
	command "debconf-set-selections <<< \"postfix postfix/main_mailer_type string 'Internet Site'\""
	action :run
end


w"postfix mailutils libsasl2-2 ca-certificates libsasl2-modules".each |pkg| do
	package pkg do
		action :install
	end
end
