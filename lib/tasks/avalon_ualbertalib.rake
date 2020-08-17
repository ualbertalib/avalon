namespace :avalon do
    namespace :ualbertalib do
      desc "Given a set of MediaObject IDs, in a file, one-per-line, update visibility to 'restricted'"
      task :visibility_restricted => :environment do

        options = {:commit => false}
        option_parser = OptionParser.new do |opts|
          opts.banner = "Usage: rake avalon:ualbertalib:visibility_restricted [options]"
          opts.on("-c", "--commit", "Commit change; override default dry-run") { 
            options[:commit] = true 
          }
          opts.on("-m ARG", "--media_objects", "File containing list of MediaObject IDs, one per line") { 
            |filename| options[:filename] = filename 
          }
          opts.on("-h", "--help") do 
             puts opts
             exit 
          end
        end

        # return `ARGV` with the intended arguments
        args = option_parser.order!(ARGV) {}
        option_parser.parse!(args)

        if options[:commit] 
          puts "Committing changes"
        else
          puts "Executing a 'dry-run' (no changes commited); use '-c' to save the change."
        end

        if options[:filename].nil?
          puts "Manditory argument: -m filename"
          puts option_parser.help
          exit 1
        elsif !File.exist?(options[:filename])
          puts "Filename not found: #{options[:filename]}"
          exit 1
        end

        mediaobject_ids = File.read(options[:filename]).split

        count = 0
        count_success = 0
        mediaobject_ids.each do |id|
          begin  
            count += 1
            obj = MediaObject.find(id)  
            old_visibility = obj.visibility
            obj.visibility = 'restricted' 
            if obj.valid?
              obj.save! if options[:commit] # default to dry-run unless commit specified 
              puts "[success] old:[#{old_visibility}] new:[#{obj.visibility}] id:[#{obj.id}]"
              count_success += 1
            else
              puts "[fail] old:[#{old_visibility}] new:[#{obj.visibility}] id:[#{obj.id}]"
              raise StandardError, "validation failure on id: #{id}, visibility change not saved"
            end
          rescue StandardError => e
            puts "Error: %s - %s - %s" % [id, e.class.name, e.message]
          end
        end
        puts "Number processed: [#{count}]; success: [#{count_success}]"
        if count == 0
          puts "You must specify an set of MediaObject IDs."
          puts option_parser.help
          exit 1
        end
      end
      
    end
  end
