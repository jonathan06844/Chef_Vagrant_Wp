require 'spec_helper'

describe service('mysql'), :if => os[:family] == 'ubuntu' do
    it { should be_enabled }
end

describe service('mysqld'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
end