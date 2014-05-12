#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2014, ASSA ABLOY AB
#
# All rights reserved - Do Not Redistribute
#

include_recipe("haproxy::setup")
include_recipe("haproxy::deploy")
