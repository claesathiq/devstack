#
# Cookbook Name:: chef-serv
# Recipe:: default
#
# Copyright 2014, ASSA ABLOY AB
#
# All rights reserved - Do Not Redistribute
#

include_recipe("chef-serv::setup")
include_recipe("chef-serv::deploy")
