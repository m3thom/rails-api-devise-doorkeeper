module Devise
  module DeviseDoorkeeperable
    extend ActiveSupport::Concern

    included do
      skip_before_action :doorkeeper_authorize!
      before_action :application_authorize!

      protected

      def find_or_create_access_token_from_resource!
        # create access token for the user, so the user won't need to login again after registration
        # ref: https://github.com/doorkeeper-gem/doorkeeper/issues/846#issuecomment-230297646
        @access_token ||= Doorkeeper::AccessToken.create!(
            resource_owner_id: resource.id,
            application_id: @client&.id,
            refresh_token: generate_refresh_token,
            expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
            scopes: ''
        )
      end

      def generate_refresh_token
        loop do
          # generate a random token string and return it,
          # unless there is already another token with the same string
          token = SecureRandom.hex(32)
          break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
        end
      end

      def render_access_token_from_resource
        find_or_create_access_token_from_resource!
        # return json containing access token and refresh token
        # so that user won't need to call login API right after registration
        # ref: https://github.com/doorkeeper-gem/doorkeeper/wiki/Customizing-Token-Response
        render json: Doorkeeper::OAuth::TokenResponse.new(@access_token).body
      end

      def application_authorize!
        @credentials = Doorkeeper::OAuth::Client::Credentials.from_basic(request)

        @client = Doorkeeper::Application.by_uid_and_secret(*@credentials)

        render json: { error: 'Invalid client ID' }, status: 403 unless @client
      end
    end
  end
end