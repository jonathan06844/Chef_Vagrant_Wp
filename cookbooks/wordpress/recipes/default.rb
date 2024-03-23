if node != nil && node['config'] != nil
    db_ip = node['config']['db_ip'] || "127.0.0.1"
else
    db_ip = "127.0.0.1"
end

execute "add host" do
    command "echo '#{db_ip}       db.epnewman.edu.pe' >> /etc/hosts"
    action :run
end

case node['platform_family']
when 'debian', 'ubuntu'
    execute "update" do
        command "apt update -y && apt upgrade -y"
        action :run
    end
    include_recipe 'wordpress::ubuntu_web'    # Instalamos el servidor web
    include_recipe 'wordpress::ubuntu_wp'     # Instalamos wordpress
when 'rhel', 'fedora'
    execute "update" do
        command "sudo dnf update -y && sudo dnf upgrade -y"
        action :run
    end
    include_recipe 'wordpress::centos_web'    # Instalamos el servidor web
    include_recipe 'wordpress::centos_wp'     # Instalamos wordpress
end

if node != nil && node['config'] != nil
    include_recipe 'wordpress::post_install'
end