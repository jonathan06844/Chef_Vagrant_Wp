# Instalar WP CLI
remote_file '/tmp/wp' do
  source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Mover WP CLI a /bin
execute 'Move WP CLI' do
  command 'mv /tmp/wp /bin/wp'
  not_if { ::File.exist?('/bin/wp') }
end

# Hacer WP CLI ejecutable
file '/bin/wp' do
  mode '0755'
end

# Instalar WordPress en español y configurar
execute 'Finish Wordpress installation' do
  command <<-CMD
    sudo -u vagrant -i -- wp core language install es_ES
    sudo -u vagrant -i -- wp core install --path=/opt/wordpress/ --url=localhost --title="ACTIVIDAD - Herramientas de automatización de despliegues" --admin_user=admin --admin_password="Lima2023." --admin_email=jonathan06844@gmail.com
  CMD
  not_if 'wp core is-installed', environment: { 'PATH' => '/bin:/usr/bin:/usr/local/bin' }
end