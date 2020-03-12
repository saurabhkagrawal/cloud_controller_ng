module VCAP::CloudController
  class SecurityGroupApply
    class Error < ::StandardError
    end

    class << self
      def apply(security_group, message, readable_space_guids)
        spaces = valid_spaces(message.space_guids, readable_space_guids)

        SecurityGroup.db.transaction do
          spaces.each { |space| security_group.add_space(space) }
        end
      rescue Sequel::ValidationFailed => e
        error!(e.message)
      end

      private

      def valid_spaces(requested_space_guids, readable_space_guids)
        existing_spaces = Space.where(guid: requested_space_guids).all
        existing_space_guids = existing_spaces.map(&:guid)

        nonexistent_space_guids = requested_space_guids - existing_space_guids
        unreadable_space_guids = existing_space_guids - readable_space_guids

        invalid_space_guids = nonexistent_space_guids + unreadable_space_guids
        error!("Spaces with guids #{invalid_space_guids} do not exist, or you do not have access to them.") if invalid_space_guids.any?

        existing_spaces
      end

      def error!(message)
        raise Error.new(message)
      end
    end
  end
end
