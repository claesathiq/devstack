#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe("gitlab::setup")
include_recipe("gitlab::deploy")
