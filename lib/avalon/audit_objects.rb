module Avalon::AuditObjects

  def self.run
    bad_objects = []
    ActiveFedora::Base.all.each do |object|
      bad_objects << object unless object.valid?
    end
    return unless bad_objects.any?
    AuditObjectsMailer.error_report(bad_objects, error_stats(bad_objects)).deliver
  end

  def self.error_stats(bad_objects)
    # Each entry has keys :heading and :value to render as a table

    # Total errors
    stats = [ { heading: I18n.t('audit.total_header_html').html_safe,
                value: bad_objects.count } ]
    object_class_counts = {}
    collection_counts = {}

    bad_objects.each do |object|
      # Count occurences for each object class
      object_class_counts[object.class] ||= 0
      object_class_counts[object.class] += 1

      # Count occurences for each object class
      if object.respond_to?(:collection)
        collection_counts[object.collection.name] ||= 0
        collection_counts[object.collection.name] += 1
      end
    end
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
