require 'spec_helper'

describe 'database::default' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge(described_recipe) }

    before do
        puts "Running tests for Ubuntu 20.04 platform..."
        stub_command('mysql -e "SHOW DATABASES;" | grep wordpress').and_return(false)
        stub_command("mysql -e \"SELECT User, Host FROM mysql.user WHERE User = 'wordpress' AND Host = '127.0.0.1'\" | grep wordpress").and_return(false)
        stub_command('::File.exist?("/etc/mysql/mysql.conf.d/mysqld.cnf")').and_return(true)
    end

    describe 'Update OS' do
        it { is_expected.to run_execute('update') }
    end

    it 'installs mysql-server' do
        expect(chef_run).to install_apt_package('mysql-server')
    end

    it 'enables and starts the mysql service' do
        expect(chef_run).to enable_service('mysql')
        expect(chef_run).to start_service('mysql')
    end

    describe 'creates the wordpress database' do
        it { is_expected.to run_execute('create_mysql_database') }
    end

    describe 'creates the mysql user and grants privileges' do
        it { is_expected.to run_execute('create_mysql_user') }
    end
end
