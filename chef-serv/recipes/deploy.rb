#
# Cookbook Name:: chef-serv
# Recipe:: deploy
#
# Copyright 2014, ASSA ABLOY AB
#
# All rights reserved - Do Not Redistribute
#

include_recipe "aws"

aws_ebs_volume "db_ebs_volume" do
  aws_access_key aws['aws_access_key_id']
  aws_secret_access_key aws['aws_secret_access_key']
  size 60
  device "/dev/sdf"
  action [ :create, :attach ]
end

