# frozen_string_literal: true

# This class serves as a base for application services.
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
