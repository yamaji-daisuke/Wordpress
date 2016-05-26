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

# create database
root_password = node["mysql"]["root_password"]
db_name = node["mysql"]["db_name"]
execute "create_db" do
  command "/usr/bin/mysql -u root < #{Chef::Config[:file_cache_path]}/create_db.sql"
  action :nothing
  not_if "/usr/bin/mysql -u root -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_db.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_db.sql.erb"
  variables({
    :db_name => db_name,
  })
  notifies :run, "execute[create_db]", :immediately
end

# create user
user_name     = node["mysql"]["user"]["name"]
user_password = node["mysql"]["user"]["password"]
execute "create_user" do
  command "/usr/bin/mysql -u root < #{Chef::Config[:file_cache_path]}/create_user.sql"
  action :nothing
  not_if "/usr/bin/mysql -u #{user_name} -p#{user_password} -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_user.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_user.sql.erb"
  variables({
    :db_name => db_name,
    :username => user_name,
    :password => user_password,
  })
  notifies :run, "execute[create_user]", :immediately
end
