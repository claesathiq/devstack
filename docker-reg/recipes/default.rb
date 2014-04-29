#
# Cookbook Name:: docker-reg
# Recipe:: default
#
# Copyright 2014, ASSA ABLOY AB
#
# All rights reserved - Do Not Redistribute
#

include_recipe("docker-reg::setup")
include_recipe("docker-reg::deploy")
