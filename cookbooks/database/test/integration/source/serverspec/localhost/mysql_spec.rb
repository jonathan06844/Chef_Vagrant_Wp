require 'spec_helper'

describe package('mysql-server') do
    it { should be_installed }
end

describe port(3306) do
    it { should be_listening }
end

describe 'MySQL config parameters', :if => os[:family] == 'ubuntu' do
    context mysql_config('socket') do
        its(:value) { should eq '/var/run/mysqld/mysqld.sock' }
    end
end

describe 'MySQL config parameters', :if => os[:family] == 'redhat' do
    context mysql_config('socket') do
        its(:value) { should eq '/var/lib/mysql/mysql.sock' }
    end
end