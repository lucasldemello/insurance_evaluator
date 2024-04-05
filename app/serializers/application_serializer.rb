# frozen_string_literal: true

# This class serves as a base for application serializers.
class ApplicationSerializer
  def self.as_json(*args, &block)
    new(*args, &block).as_json
  end
end
