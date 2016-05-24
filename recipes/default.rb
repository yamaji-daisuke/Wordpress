#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'wordpress::nginx'
include_recipe 'wordpress::php70'
include_recipe 'wordpress::mariadb'
