package "httpd" do
    action :install
end

package "php" do
    action :install
end

package "php-mysqlnd" do
    action :install
end

package "php-json" do
  action :install
end

package "unzip" do
    action :install
end

package "curl" do
    action :install
end

file "/var/www/html/info.php" do
    content "<?php\nphpinfo();\n?>" 
end

selinux_boolean 'httpd_can_network_connect' do
    value true
    action :set
end

selinux_boolean 'httpd_can_network_connect_db' do
    value true
    action :set
end

execute 'firewall-cmd --zone=public --add-port=8080/tcp --permanent' do
    action :run
end

execute 'firewall-cmd --zone=public --add-port=80/tcp --permanent' do
    action :run
end

execute 'firewall-cmd --reload' do
    action :run
end

service "httpd" do
    action [:enable, :start]
end