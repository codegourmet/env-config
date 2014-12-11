# EnvConfig

Basic ruby environment-dependent configuration

## usage example:

``` ruby
# environment.rb
EnvConfig.configure(:default) do |config|
  config[:verbose] = true
end

# test.rb
EnvConfig.configure(:test) do |config|
  config[:verbose] = false
end

# development.rb
EnvConfig.configure(:development) do |config|
end


config = EnvConfig.new(:test)
config[:verbose] # => false

config = EnvConfig.new(:development)
config[:verbose] # => true
```

## Exceptions

``` ruby
config[:unknown_key_12345] # => EnvConfig::ArgumentError

config = EnvConfig.new(:unknown_env_123) # => EnvConfig::UnknownEnvironmentError

config = EnvConfig.new(:default) # => EnvConfig::AbstractError

EnvConfig.configure(:test) do ...
EnvConfig.configure(:default) do ... # => EnvConfig::LoadOrderError

config[:verbose] = false # => EnvConfig::ImmutableError
```
