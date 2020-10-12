# frozen-string-literal: true

require 'fcmpush'
require 'active_support/core_ext/hash/transform_values'

module Pushing
  module Adapters
    class FcmpushAdapter
      attr_reader :project_id

      def initialize(fcm_settings)
        @project_id = fcm_settings.project_id
        if fcm_settings.json_key_io.present?
          Fcmpush.configure do |config|
            config.json_key_io = fcm_settings.json_key_io
          end
        end
      end

      def push!(notification)
        result = client.push(message: notification.payload)
        FcmResponse.new(result.response)
      rescue => e
        response = FcmResponse.new(e.response) if e.response
        error    = Pushing::FcmDeliveryError.new("Error while trying to send push notification: #{e.message}", response, notification)

        raise error, error.message, e.backtrace
      end

      private

      def client
        @client ||= Fcmpush.new(project_id)
      end

      class FcmResponse < Fcmpush::JsonResponse
        def code
          __getobj__.code.to_i
        end
      end

      private_constant :FcmResponse
    end
  end
end
