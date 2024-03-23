if node != nil && node['config'] != nil
    db_user = node['config']['db_user'] || "wordpress"
    db_pswd = node['config']['db_pswd'] || "wordpress"
    wp_ip   = node['config']['wp_ip'] || "127.0.0.1"
else
    db_user = "wordpress"
    db_pswd = "wordpress"
    wp_ip   = "127.0.0.1"
end

# Instalar MySQL server
package 'mysql-server' do
    action :install
end

# Habilitar el servicio MySQL
service "mysqld" do
    action [:enable, :start]
end

# Ejecutar comando para crear la base de datos
execute 'create_mysql_database' do
    command 'mysql -e "CREATE DATABASE wordpress;"'
    action :run
    not_if 'mysql -e "SHOW DATABASES;" | grep wordpress'
end

# Ejecutar comando para crear el usuario y otorgar permisos
execute 'create_mysql_user' do
    command "mysql -e \"CREATE USER '#{db_user}'@'#{wp_ip}' IDENTIFIED BY '#{db_pswd}'; GRANT ALL PRIVILEGES ON wordpress.* TO '#{db_user}'@'#{wp_ip}'; FLUSH PRIVILEGES;\""
    action :run
    not_if "mysql -e \"SELECT User, Host FROM mysql.user WHERE User = '#{db_user}' AND Host = '#{wp_ip}'\" | grep #{db_user}"
end

execute 'firewall-cmd --zone=public --add-port=3306/tcp --permanent' do
    action :run
end

execute 'firewall-cmd --reload' do
    action :run
end