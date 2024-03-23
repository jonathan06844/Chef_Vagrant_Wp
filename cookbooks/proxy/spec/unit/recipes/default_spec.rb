require 'spec_helper'

describe 'proxy::default' do
    context 'on Ubuntu' do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge(described_recipe) }

        describe 'Update OS' do
            it { is_expected.to run_execute('update') }
        end

        describe 'Install and configure Nginx' do
            it { is_expected.to install_package('nginx') }
            it { is_expected.to create_template('/etc/nginx/nginx.conf') }
            it { is_expected.to start_service('nginx') }
        end
  end

    context 'on CentOS' do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '8').converge(described_recipe) }

        describe 'Update OS' do
            it { is_expected.to run_execute('update') }
        end

        describe 'Install and configure Nginx' do
            it { is_expected.to install_package('nginx') }
            it { is_expected.to create_template('/etc/nginx/nginx.conf') }
            it { is_expected.to start_service('nginx') }
            it { is_expected.to run_execute('firewall-cmd --zone=public --add-port=80/tcp --permanent') }
            it { is_expected.to run_execute('firewall-cmd --reload') }
        end
    end
end
