# Copyright 2011-2015, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
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

require 'roo'

module Avalon
  module Batch
    class Manifest
      include Enumerable
      include ActionView::Helpers::TranslationHelper

      extend Forwardable

      EXTENSIONS = ['csv','xls','xlsx','ods']
      FILE_FIELDS = [:file,:label,:offset,:skip_transcoding,:absolute_location,:date_digitized]
      SKIP_FIELDS = [:collection]

      def_delegators :@entries, :each
      attr_reader :spreadsheet, :file, :name, :email, :entries, :package, :manifest_logger

      class << self
        def locate(root)
          locate_with_status(root)[:processable]
        end

        def locate_with_status(root)
          status = {
            processable: [],
            processing: [],
            processed: [],
            error: []
          }
          possibles = Dir[File.join(root, "**/*.{#{EXTENSIONS.join(',')}}")]
          possibles.each do |file|
            next if File.basename(file) =~ /^~\$/
            if self.error?(file)
              status[:error] << file
            elsif self.processing?(file)
              status[:processing] << file
            elsif self.processed?(file)
              status[:processed] << file
            else
              status[:processable] << file
            end
          end
          status
        end

        def concatenate_log_files(root)
          # Note: we want to return nil if no logs exist
          output = nil
          locate_with_status(root).each do |status, manifests|
            manifests.each do |manifest|
              log_file = "#{manifest}.log"
              next unless File.exists?(log_file)
              output ||= ''
              file = File.open(log_file, "rb")
              output += "** #{log_file} (#{status}) **\n#{file.read}\n\n"
              file.close
            end
          end
          output
        end

        def error?(file)
          if File.file?("#{file}.error")
            if File.mtime(file) > File.mtime("#{file}.error")
              File.unlink("#{file}.error")
              return false
            else
              return true
            end
          end
          return false
        end

        def processing?(file)
          File.file?("#{file}.processing")
        end

        def processed?(file)
          File.file?("#{file}.processed")
        end
      end

      def initialize(file, package)
        @file = file
        @package = package

        # Ensure that the log file is overwritten on each ingest (default append)
        log_file = File.open("#{file}.log", 'w')
        @manifest_logger = Logger.new(log_file)

        load!
      end

      def load!
        @entries = []
        begin
          @spreadsheet = Roo::Spreadsheet.open(file)
          @name = @spreadsheet.row(@spreadsheet.first_row)[0]
          @email = @spreadsheet.row(@spreadsheet.first_row)[1]

          header_row = @spreadsheet.row(@spreadsheet.first_row + 1)

          @field_names = header_row.collect { |field| 
            field.to_s.downcase.gsub(/\s/,'_').strip.to_sym 
          }
          create_entries!
        rescue Exception => err
          error! "Invalid manifest file: #{err.message}"
        end
      end

      def start!
        File.open("#{@file}.processing",'w') { |f| f.puts Time.now.xmlschema }
        manifest_logger.info(t('batch_ingest.logger.processing_started', file: @file))
      end

      def error! msg=nil
        File.open("#{@file}.error",'a') do |f| 
          if msg.nil?
            has_logged_error = false
            entries.each do |entry|
              if entry.errors.count > 0
                msg = "#{t('batch_ingest.logger.row', row: entry.row)}\n" +
                  entry.errors.full_messages.map { |m| "  #{m}"}.join("\n")
                f.puts(msg)
                manifest_logger.error(msg)
                has_logged_error = true
              end
            end
            manifest_logger
              .error(t('batch_ingest.logger.unknown_error')) unless has_logged_error
          else
            # Let's make msg either string or array of strings
            msg_out = Array(msg).join("\n")
            f.puts(msg_out)
            manifest_logger.error(msg_out)
          end
        end
        rollback! if processing?
      end

      def rollback!
        File.unlink("#{@file}.processing")
      end

      def commit!
        File.open("#{@file}.processed",'w') { |f| f.puts Time.now.xmlschema }
        rollback! if processing?
        manifest_logger.info(t('batch_ingest.logger.finished_processing', file: @file))
      end

      def error?
        result = self.class.error?(@file)
        load! unless result
        result
      end

      def processing?
        self.class.processing?(@file)
      end

      def processed?
        self.class.processed?(@file)
      end

      def errors
        @errors ||= []
      end

      private
      def true?(value)
        not (value.to_s =~ /^(y(es)?|t(rue)?)$/i).nil?
      end

      def create_entries!
        f = @spreadsheet.first_row + 2
        l = @spreadsheet.last_row
        f.upto(l) do |index|
          opts = {
            :publish => false,
            :hidden  => false
          }

          values = @spreadsheet.row(index).collect do |val|
            (val.is_a?(Float) and (val == val.to_i)) ? val.to_i.to_s : val.to_s
          end
          content=[]

          fields = Hash.new { |h,k| h[k] = [] }
          @field_names.each_with_index do |f,i| 
            unless f.blank? || SKIP_FIELDS.include?(f) || values[i].blank?
              if FILE_FIELDS.include?(f)
                content << {} if f == :file
                content.last[f] = f == :skip_transcoding ? true?(values[i]) : values[i]
              else
                fields[f] << values[i] 
              end
            end
          end

          opts.keys.each { |opt|
            val = Array(fields.delete(opt)).first.to_s
            if opts[opt].is_a?(TrueClass) or opts[opt].is_a?(FalseClass)
              opts[opt] = true?(val)
            else
              opts[opt] = val
            end
          }
          entries << Entry.new(fields.select { |f| !FILE_FIELDS.include?(f) }, content, opts, index, self)
        end
      end

    end
  end
end
