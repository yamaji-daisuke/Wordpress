#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'nginx' do
  action :install
end

service "nginx" do
  action [ :enable, :start]
  supports :start => true, :restart => true, :enable => true
end

cookbook_file "/etc/nginx/conf.d/wordpress.conf" do
  source "wordpress.conf"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[nginx]"
end

cookbook_file "/usr/share/nginx/html/info.php" do
  source "info.php"
  owner "root"
  group "root"
  mode 0644
end

