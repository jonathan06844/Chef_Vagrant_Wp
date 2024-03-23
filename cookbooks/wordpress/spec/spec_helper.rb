require 'chefspec'
require 'chefspec/policyfile'

# Carga el archivo custom_matchers.rb
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
