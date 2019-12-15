module Helpers
  def json_fixture(filename)
    JSON.parse(File.read(Rails.root.join("spec/fixtures/json/#{filename}")))
  end

  def json_response
    JSON.parse(response.body)
  end

  def json_data
    json_response['data']
  end

  def json_erb_fixture(filename, options = {})
    data = File.read(Rails.root.join("spec/fixtures/json/#{filename}"))
    JSON.parse(ERB.new(data).result(ErbBinding.new(options).binding))
  end
end
