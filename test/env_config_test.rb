require_relative "test_helper"
require_relative "../lib/env_config"

class EnvConfigTest < MiniTest::Test

  def setup
    EnvConfig.configure(:default) do |config|
      config[:default_test_setting] = 'default default_test_setting'
    end

    EnvConfig.configure(:test) do |config|
      config[:test_setting] = 'test test_setting'
    end

    EnvConfig.configure(:development) do |config|
      config[:test_setting] = 'dev test_setting'
    end
  end

  def test_raises_if_unknown_environment
    assert_raises EnvConfig::UnknownEnvironmentError do
      EnvConfig.new('unknown')
    end
  end

  def test_raises_if_default_isnt_loaded_first
    EnvConfig.send(:class_variable_set, :@@configurations, {})

    assert_raises EnvConfig::LoadOrderError do
      EnvConfig.configure(:test) do |config|
        config[:test_setting] = 'test test_setting'
      end
    end
  end

  def test_default_applies_if_key_not_set
    EnvConfig.configure(:test2) do |config|
    end
    config = EnvConfig.new(:test2)
    assert_equal 'default default_test_setting', config[:default_test_setting]
  end

  def test_environment_specific_setting_overrides_default
    EnvConfig.configure(:test2) do |config|
      config[:default_test_setting] = 'overwritten default_test_setting'
    end
    config = EnvConfig.new(:test2)
    assert_equal 'overwritten default_test_setting', config[:default_test_setting]
  end

  def test_prevents_instantiation_of_default_values_as_environment
    assert_raises EnvConfig::AbstractError do
      EnvConfig.new(:default)
    end
  end

  def test_initialize_uses_chosen_config
    config = EnvConfig.new('test')
    assert_equal 'test test_setting', config[:test_setting]

    config = EnvConfig.new('development')
    assert_equal 'dev test_setting', config[:test_setting]
  end

  def test_initialize_sets_environment
    config = EnvConfig.new('test')
    assert_equal :test, config.environment

    config = EnvConfig.new('development')
    assert_equal :development, config.environment
  end

  def test_config_is_immutable
    config = EnvConfig.new('test')

    assert_raises EnvConfig::ImmutableError do
      config[:test_setting] = 3
    end
  end

end
