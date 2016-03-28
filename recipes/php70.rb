#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'wordpress::php70 install epel' do
  command 'yum -y install epel-release'
  action :run
  ignore_failure true
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

execute 'wordpress::php70 install php70' do
  command 'yum --enablerepo=epel,remi,remi-php70 install php70'
  action :run
end

execute 'wordpress::php70 setting path' do
  command <<-EOH
    cp /opt/remi/php70/enable /etc/profile.d/php70.sh
    source /opt/remi/php70/enable
  EOH
  action :run
  ignore_failure true
end

execute 'wordpress::php70 install php extensions' do
  command 'yum --enablerepo=epel,remi,remi-php70 install php70-php-mcrypt php70-php-mbstring php70-php-gd php70-php-mysql php70-php-fpm'
  action :run
end


