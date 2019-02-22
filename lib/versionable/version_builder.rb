require_relative "concerns/change_detection"
require_relative "concerns/option_normalization"
require_relative "concerns/parent_finding"
require_relative "concerns/traversing"

module Versionable
  class VersionBuilder
    include ChangeDetection
    include OptionNormalization
    include ParentFinding
    include Traversing

    attr_reader :record

    def initialize(source_record)
      @record = get_parent(source_record)
      if record.present?
        @included_paths = get_included_paths(record.class.versionable_options)
        @records_before = traverse(record, @included_paths)
      end
    end

    def store(author)
      results = []
      if record.present? && !record.new_record?
        record.run_callbacks :store_versions do
          results = (@records_before + traverse(record, @included_paths)).uniq.map do |subject|

            destroyed = false
            begin
              subject.reload
            rescue ActiveRecord::RecordNotFound
              destroyed = true
            end
            last_version = subject.versions.order(:created_at).last

            event = destroyed ? :destroy : last_version.present? ? :update : :create

            previous_snapshot = last_version.try(:data_snapshot) || {}
            current_snapshot = get_snapshot(subject)
            diff = diff(previous_snapshot, current_snapshot)

            if event != :update || diff.any?
              version = Versionable::Version.create(
                event: event,
                author: author,
                versionable: subject,
                data_snapshot: current_snapshot,
                data_changes: diff
              )
            end

          end.compact
        end
      end
      results
    end

    private

    def get_snapshot(subject)
      options = normalize_options(subject.class.versionable_options)
      JSON.parse(subject.to_json(options))
    end
  end
end
