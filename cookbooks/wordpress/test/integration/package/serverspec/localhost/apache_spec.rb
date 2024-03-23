require 'spec_helper'

describe service('apache2'), :if => os[:family] == 'ubuntu' do
    it { should be_enabled }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
end