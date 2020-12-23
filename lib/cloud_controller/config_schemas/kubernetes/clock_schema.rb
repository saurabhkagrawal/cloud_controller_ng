require 'vcap/config'
require 'cloud_controller/config_schemas/base/clock_schema'

module VCAP::CloudController
  module ConfigSchemas
    module Kubernetes
      class ClockSchema < VCAP::Config
        self.parent_schema = VCAP::CloudController::ConfigSchemas::Base::ClockSchema

        class << self
          delegate :configure_components, to: :parent_schema
        end
      end
    end
  end
end
