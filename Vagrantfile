Vagrant.configure("2") do |config|
    config.env.enable              # Habilitamos vagrant-env(.env)

    if ENV['TESTS'] == 'true'
        config.vm.define "test" do |testing|
            testing.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"  # Utilizamos una imagen de Ubuntu 20.04 por defecto

            testing.vm.provision "shell", inline: <<-SHELL
                # Instalar ChefDK
                wget -qO- https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk

                export CHEF_LICENSE="accept"

                # Instalar las gemas necesarias para las pruebas
                cd /vagrant/cookbooks/database && chef exec bundle install
                cd /vagrant/cookbooks/wordpress && chef exec bundle install
                cd /vagrant/cookbooks/proxy && chef exec bundle install

                chown -R vagrant:vagrant /opt/chefdk
            SHELL
        end
    else
        config.vm.define "database" do |db|
            db.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"  # Utilizamos una imagen de Ubuntu 20.04 por defecto
            db.vm.hostname = "db.actividad.edu.pe"
            db.vm.network "private_network", ip: ENV["DB_IP"]

            db.vm.provision "chef_solo" do |chef|
                chef.install = "true"
                chef.arguments = "--chef-license accept"
                chef.add_recipe "database"
                chef.json = {
                    "config" => {
                        "db_ip" => "#{ENV["DB_IP"]}",
                        "wp_ip" => "#{ENV["WP_IP"]}",
                        "db_user" => "#{ENV["DB_USER"]}",
                        "db_pswd" => "#{ENV["DB_PSWD"]}"
                    }
                }
            end
        end

        config.vm.define "wordpress" do |sitio|
            sitio.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"  # Utilizamos una imagen de Ubuntu 20.04 por defecto
            sitio.vm.hostname = "wordpress.actividad.edu.pe"
            sitio.vm.network "private_network", ip: ENV["WP_IP"]

            sitio.vm.provision "chef_solo" do |chef|
                chef.install = "true"
                chef.arguments = "--chef-license accept"
                chef.add_recipe "wordpress"
                chef.json = {
                    "config" => {
                        "db_ip" => "#{ENV["DB_IP"]}",
                        "db_user" => "#{ENV["DB_USER"]}",
                        "db_pswd" => "#{ENV["DB_PSWD"]}"
                    }
                }
            end
        end

        config.vm.define "proxy" do |proxy|
            proxy.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"  # Utilizamos una imagen de Ubuntu 20.04 por defecto
            proxy.vm.hostname = "wordpress.actividad.edu.pe"
            proxy.vm.network "private_network", ip: ENV["PROXY_IP"]

            proxy.vm.provision "chef_solo" do |chef|
                chef.install = "true"
                chef.arguments = "--chef-license accept"
                chef.add_recipe "proxy"
                chef.json = {
                    "config" => {
                        "wp_ip" => "#{ENV["WP_IP"]}"
                    }
                }
            end
        end
    end
end