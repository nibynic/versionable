module Versionable
  module ParentFinding
    extend ActiveSupport::Concern

    class InfiniteParentLoopError < StandardError
      def initialize(trace)
        @trace = trace.map { |r| [r.class.name, r.id || "new"].join("#") }.join(" -> ")
      end

      def message
        "Versionable got stuck in an infinite parent loop: #{@trace}"
      end
    end

    private

    def get_parent(source)
      visited = [source]
      loop do
        parent_def = (source.class.try(:versionable_options) || {})[:parent]
        break if parent_def.nil?
        source = case parent_def
        when String, Symbol then source.send(parent_def)
        when Proc then source.instance_exec(&parent_def)
        end
        break if source == visited.last
        raise InfiniteParentLoopError.new(visited + [source]) if visited.include?(source)
        visited << source
      end
      source
    end
  end
end
