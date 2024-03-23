package "apache2" do
    action :install
end

package "php" do
    action :install
end

package "php-mysql" do
    action :install
end

package "php-mysqlnd" do
    action :install
end

package "php-mysqli" do
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

service "apache2" do
    action [:enable, :start]
end