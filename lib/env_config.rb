# usage example:
#
# # environment.rb
# EnvConfig.configure(:default) do |config|
#   config[:verbose] = true
# end
#
# # test.rb
# EnvConfig.configure(:test) do |config|
#   config[:verbose] = false
# end
#
# # development.rb
# EnvConfig.configure(:development) do |config|
# end
#
#
# config = EnvConfig.new(:test)
# config[:verbose] # => false
#
# config = EnvConfig.new(:development)
# config[:verbose] # => true
#
class EnvConfig

  class UnknownEnvironmentError < RuntimeError ; end
  class AbstractError < RuntimeError ; end
  class LoadOrderError < RuntimeError ; end
  class ImmutableError < RuntimeError ; end

  @@configurations = {}

  attr_reader :environment

  def self.configure(environment)
    environment = environment.to_sym
    set_default_values(environment)
    yield @@configurations[environment]
  end

  def initialize(environment)
    @environment = environment.to_sym
    raise AbstractError if @environment == :default
    raise UnknownEnvironmentError if !@@configurations.has_key?(@environment)
  end

  def [](key)
    get_config[key]
  end

  # NOTE this ensures readonly only for toplevel key=>value,
  # not the value objects themselves
  def []=(key, value)
    raise ImmutableError.new("config is read-only")
  end

  protected

    def self.set_default_values(environment)
      if environment == :default
        @@configurations[environment] = {}
      else
        if !@@configurations.has_key?(:default)
          raise LoadOrderError.new("have to define :default configuration first")
        end
        # TODO raise default not found error if doesnt exist yet!
        @@configurations[environment] = @@configurations[:default].clone
      end
    end

    def get_config
      @@configurations[@environment]
    end
end

require 'version'
