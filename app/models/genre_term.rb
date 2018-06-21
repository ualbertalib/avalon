# Copyright 2017, University of Alberta Libraries.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

class GenreTerm < Struct.new(:id, :text, :uri)
  class LookupError < Exception; end
  class DuplicateKeyError < Exception; end

  STORE = File.join(Rails.root, 'config/pbcore_genre.csv')

  @@map = nil

  class << self

    def map
      @@map ||= self.load!
    end
    
    def find(value)
      result = self.map[normalize_text(value).to_sym]
      raise LookupError, "Unknown genre: `#{value}'" if result.nil?
      return result
    end
    alias_method :[], :find

    def has_term?(value)
      # Is the term in the vocabulary?
      begin
        self.find(value)
      rescue LookupError
        return false
      end
      return true
    end
 
    def autocomplete(query)
      results = query.present? ?
        self.map.select{ |k,v| /#{query}/i.match(v.text) if v } : self.map

      # Sort by Levenshtein (normalized) first, alphabetical second
      # (this way, for query="ar", "Art" comes before "War")
      nquery = normalize_text(query)
      results.map{ |k, e| {id: k.to_s, uri: e.uri, display: e.text }}.
        sort_by { |x| [ Levenshtein.distance(x[:id], nquery), x[:display] ] }
    end

    def normalize_text(text)
      text.downcase.gsub(/[^a-zA-Z0-9_]+/, '_')
    end

    def load!
      # The format of the CSV file is "label, uri" (header on first line)
      data_map = {}
      if File.exists?(STORE)
        csv_contents = CSV.read(STORE)
        # Skip header line ...
        csv_contents.shift
        csv_contents.each do |row|
          text = row[0]
          uri = row[1]
          key = normalize_text(text).to_sym
          raise DuplicateKeyError if data_map.has_key?(key)
          data_map[key] = GenreTerm.new(key, text, uri)
        end
      end
      return data_map
    end

  end

end
