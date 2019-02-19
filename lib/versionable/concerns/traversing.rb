module Versionable
  module Traversing
    extend ActiveSupport::Concern

    private

    def traverse(record, except = [], path = nil, visited = [])
      unless visited.include?(record) || !record.respond_to?(:store_versions)
        list = except.include?(path) ? [] : [record]
        record.class.reflect_on_all_associations.each do |reflection|
          if reflection.collection?
            related = record.send(reflection.name)
          else
            related = [record.send(reflection.name)].compact
          end
          list += related.map do |r|
            traverse(r, except, [path, reflection.name].compact.join("."), visited + [record])
          end.reduce([], :+)
        end
        list
      else
        []
      end
    end
  end
end
