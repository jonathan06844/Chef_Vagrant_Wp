if defined?(ChefSpec)
    def selinux_boolean(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:selinux_boolean, :set, resource_name)
    end
end
