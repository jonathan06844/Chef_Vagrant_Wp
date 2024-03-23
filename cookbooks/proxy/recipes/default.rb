package 'nginx' do
    action :install
end

service 'nginx' do
    action [:enable, :start]
end

case node['platform_family']
when 'debian', 'ubuntu'
    execute "update" do
        command "apt update -y && apt upgrade -y"
        action :run
    end

    template '/etc/nginx/nginx.conf' do
        source 'ubuntu.conf.erb'
        action :create
        notifies :restart, 'service[nginx]', :immediately
    end
when 'rhel', 'fedora'
    execute "update" do
        command "sudo dnf update -y && sudo dnf upgrade -y"
        action :run
    end

    template '/etc/nginx/nginx.conf' do
        source 'centos.conf.erb'
        action :create
        notifies :restart, 'service[nginx]', :immediately
    end

    selinux_boolean 'httpd_can_network_connect' do
        value true
        action :set
    end

    execute 'firewall-cmd --zone=public --add-port=80/tcp --permanent' do
        action :run
    end

    execute 'firewall-cmd --reload' do
        action :run
    end
end