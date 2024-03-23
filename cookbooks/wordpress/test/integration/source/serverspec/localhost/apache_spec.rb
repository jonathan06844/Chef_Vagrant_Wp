require 'spec_helper'

describe package('apache2'), :if => os[:family] == 'ubuntu' do
    it { should be_installed }
end

describe package('httpd'), :if => os[:family] == 'redhat' do
    it { should be_installed }
end

describe port(8080) do
    it { should be_listening }
end