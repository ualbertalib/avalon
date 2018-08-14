module Avalon
  module AuditObjects

    def self.run
      bad_objects = []
      ActiveFedora::Base.all.each do |object|
        bad_objects << object unless object.valid?
      end
      return unless bad_objects.any?
      AuditObjectsMailer.error_report(bad_objects, error_stats(bad_objects)).deliver_now
    end

    def self.error_stats(bad_objects)
      # Each entry has keys :heading and :value to render as a table

      # Total errors
      stats = [ { heading: I18n.t('audit.total_header_html').html_safe,
                  value: bad_objects.count } ]

      # TODO: reduce the number of iterations in this code, see:
      #   https://github.com/ualbertalib/avalon/pull/350/files#r209375847
      object_class_counts = bad_objects.group_by(&:class).transform_values! {|v| v.length}
      collection_counts = bad_objects.select { |obj| obj.respond_to?(:collection) }
                            .group_by {|obj| obj.collection.name }
                            .transform_values! {|v| v.length }

      object_class_counts.each do |klass, count|
        stats << {
          heading: I18n.t('audit.class_total_header_html', class: klass).html_safe,
          value: count
        }
      end
      collection_counts.each do |collection, count|
        stats << {
          heading: I18n.t('audit.collection_total_header_html',
                          collection: collection).html_safe,
          value: count
        }
      end
      stats
    end

  end
end
