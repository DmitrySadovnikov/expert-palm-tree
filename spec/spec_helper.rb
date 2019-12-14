class ErbBinding
  def initialize(options = {})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def binding
    Kernel.binding
  end
end

RSpec.configure do |config|
  config.order = :random
  config.filter_run_when_matching :focus
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
