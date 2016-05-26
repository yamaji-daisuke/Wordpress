remote_file '/root/latest-ja.tar.gz' do
  source 'http://ja.wordpress.org/latest-ja.tar.gz'
  owner 'root'
  group 'root'
  mode '0444'
  action :create
  not_if { Dir.exists?("/usr/share/nginx/html/wordpress") }
end

script "install_wordpress" do
  interpreter "bash"
  user        "root"
  cwd         "/root"
  code <<-EOL
    tar xzvf latest-ja.tar.gz
    mv wordpress /usr/share/nginx/html 
  EOL
  action :run
  not_if { Dir.exists?("/usr/share/nginx/html/wordpress") }
end

db_name       = node["mysql"]["db_name"]
user_name     = node["mysql"]["user"]["name"]
user_password = node["mysql"]["user"]["password"]

template "/usr/share/nginx/html/wp-config.php" do
  owner "root"
  group "root"
  mode 0644
  source "wp-config.php.erb"
  variables({
    :db_name => db_name,
    :username => user_name,
    :password => user_password,
  })
  action :create
end
