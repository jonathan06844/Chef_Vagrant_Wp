require 'spec_helper'

describe file('/opt/wordpress/wp-config.php') do
     its(:content) { should match /define\('DB_USER', '[^']+'\);/ }
end

describe file('/etc/httpd/conf.d/wordpress.conf'), :if => os[:family] == 'redhat' do
     its(:content) { should match /Listen 8080 http/ }
end

describe file('/etc/apache2/sites-enabled/wordpress.conf'), :if => os[:family] == 'debian' do
     its(:content) { should match /Listen 8080 http/ }
end
