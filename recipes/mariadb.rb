#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%W{
  mariadb
  mariadb-server
  mariadb-devel
  mariadb-libs
}.each do |pkg|
  package "#{pkg}" do
    action :install
    options '--enablerepo=epel,remi,remi-php70'
  end
end

cookbook_file "/etc/my.cnf.d/server.cnf" do
  source "my.cnf.d/server.cnf"
  owner "root"
  group "root"
  mode 0644
end

service "mariadb" do
  action [ :enable, :start]
  supports :start => true, :restart => true, :enable => true
end


