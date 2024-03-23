require 'spec_helper'

describe 'database::default' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '8').converge(described_recipe) }

    before do
        puts "Running tests for CentOS 8 platform..."
        stub_command('mysql -e "SHOW DATABASES;" | grep wordpress').and_return(false)
        stub_command("mysql -e \"SELECT User, Host FROM mysql.user WHERE User = 'wordpress' AND Host = '127.0.0.1'\" | grep wordpress").and_return(false)
    end

    describe 'Update OS' do
        it { is_expected.to run_execute('update') }
    end

    describe 'Open port 3306 and reload firewall' do
        it { is_expected.to run_execute('firewall-cmd --zone=public --add-port=3306/tcp --permanent') }
        it { is_expected.to run_execute('firewall-cmd --reload') }
    end

    it 'installs mysql-server' do
        expect(chef_run).to install_package('mysql-server')
    end

    it 'enables and starts the mysqld service' do
        expect(chef_run).to enable_service('mysqld')
        expect(chef_run).to start_service('mysqld')
    end

    describe 'creates the wordpress database' do
        it { is_expected.to run_execute('create_mysql_database') }
    end

    describe 'creates the mysql user and grants privileges' do
        it { is_expected.to run_execute('create_mysql_user') }
    end
end