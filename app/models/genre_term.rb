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

class GenreTerm
  require 'avalon/levenshtein'
  extend Avalon::Levenshtein

  class LookupError < Exception; end
  class DuplicateKeyError < Exception; end

  STORE = File.join(Rails.root, 'config/pbcore_genre.csv')

  class << self
    def map
      @@map ||= self.load!
    end
    
    def find(value)
      result = self.map[normalize_text(value)]
      raise LookupError, "Unknown genre: `#{value}'" if result.nil?
      self.new(result)
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
      map = query.present? ?
        self.map.select{ |k,v| /#{query}/i.match(v[:text]) if v } : self.map
      map.map{ |k, e| {id: k, uri: e[:uri], display: e[:text] }}.
        sort{ |x,y| levenshtein(x[:display], query) <=> levenshtein(y[:display],query) }
    end

    def normalize_text(text)
      text.downcase.gsub(/[^a-zA-Z0-9_]+/, '_').to_sym
    end

    def load!
      data_map = {}
      if File.exists?(STORE)
        csv_contents = CSV.read(STORE)
        # Skip header line ...
        csv_contents.shift
        csv_contents.each do |row|
          text = row[0]
          uri = row[1]
          key = normalize_text(text)
          if data_map.has_key?(key)
            raise DuplicateKeyError
          end
          data_map[key] = { text: text, uri: uri }
        end
      end
      return data_map
    end

  end
  
  def initialize(term)
    @term = term
  end
  
  def id
    self.class.normalize_text(@term[:text])
  end

  def uri
    @term[:uri]
  end
  
  def text
    @term[:text]
  end
end
