require_relative "concerns/change_detection"
require_relative "concerns/option_normalization"

module Versionable
  class VersionBuilder
    include ChangeDetection
    include OptionNormalization

    attr_reader :record, :author

    def initialize(record, author)
      @record = record
      @author = author
    end

    def store
      last_version = record.versions.order(:created_at).last

      event = last_version.present? ? :update : :create

      previous_snapshot = last_version.try(:data_snapshot) || {}
      diff = diff(previous_snapshot, current_snapshot)

      if event != :change || diff.any?
        version = record.versions.create(
          event: event,
          author: author,
          data_snapshot: current_snapshot,
          data_changes: diff
        )
      end


      # if versioning_parent != false
      #   versioning_parent.store_versions(author, event, params) if versioning_parent.present?
      # else
      #   if versions.last.present?
      #     was = versions.last.object
      #     was_destroyed = versions.last.event == "destroy"
      #   end
      #   event ||= destroyed? ? :destroy : ((was.nil? || was_destroyed) ? :create : :change)
      #   is = serialize_for_versioning
      #   diff = HashDiff.diff(was, is) if was.present?
      #   if event != :change || diff.any?
      #     version = Version.create author: author, object: is, object_changes: diff, event: event, item: self
      #   end
      # end
      # if @versioning_children_were
      #   @versioning_children_were.each do |child|
      #     child.store_versions(author, event, params)
      #   end
      # end
      # version


    end

    private

    def current_snapshot
      @current_snapshot ||= JSON.parse(record.to_json(options))
    end
  end
end
