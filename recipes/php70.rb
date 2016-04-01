#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'epel-release' do
  action :install
end

remote_file '/tmp/remi-release-7.rpm' do
  source 'http://rpms.famillecollet.com/enterprise/remi-release-7.rpm'
  owner 'root'
  group 'root'
  mode '0444'
  action :create
end

execute 'wordpress::php70 install remi' do
  command 'rpm -ivh /tmp/remi-release-7.rpm'
  action :run
  ignore_failure true
  not_if { File.exists?('/etc/yum.repos.d/remi.repo') }
end

package 'php70' do
  action :install
  options '--enablerepo=epel,remi,remi-php70'
  action :install
end

execute 'wordpress::php70 setting path' do
  command <<-EOH
    cp /opt/remi/php70/enable /etc/profile.d/php70.sh
    source /opt/remi/php70/enable
  EOH
  action :run
  ignore_failure true
  not_if { File.exists?('/etc/profile.d/php70.sh') }
end

%W{
  php70-php-mcrypt
  php70-php-mbstring
  php70-php-gd
  php70-php-memcached
  php70-php-fpm
  php70-php-json
  php70-php-pdo
  php70-php-mysqlnd
}.each do |pkg|
  package "#{pkg}" do
    action :install
    options '--enablerepo=epel,remi,remi-php70'
  end
end

execute 'wordpress::php70 prepare conf files & log directory' do
  command <<-EOH
    ln -s /etc/opt/remi/php70/php.ini /etc/php.ini 
    ln -s /etc/opt/remi/php70/php.d /etc/php.d 
    ln -s /etc/opt/remi/php70/php-fpm.conf /etc/php-fpm.conf
    ln -s /etc/opt/remi/php70/php-fpm.d /etc/php-fpm.d
    mkdir /var/log/php-fpm
  EOH
  action :run
  ignore_failure true
  not_if { Dir.exists?('/var/log/php-fpm') }
end

cookbook_file "/etc/opt/remi/php70/php-fpm.conf" do
  source "php-fpm.conf"
  owner "root"
  group "root"
  mode 0644
end

cookbook_file "/etc/opt/remi/php70/php-fpm.d/www.conf" do
  source "php-fpm.d/www.conf"
  owner "root"
  group "root"
  mode 0644
end

service "php70-php-fpm" do
  action [ :enable, :start]
  supports :start => true, :restart => true, :enable => true
end


