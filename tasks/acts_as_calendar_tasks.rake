# Initializer must be run or we get uninitialized class variable @@configuration (introduced w/rails 2.1)
Rails::Initializer.run
require 'rails_generator' 
require 'rails_generator/scripts/generate' 

namespace :db do  
  namespace :migrate do  
    desc "Generate the migrations in vendor/plugins/acts_as_calendar/db/migrate"
    task :acts_as_calendar => :environment do
      migrations = ['add_acts_as_calendar_tables']
      migrations.each do |migration|
        puts "Generating migration: #{migration}"
        Rails::Generator::Scripts::Generate.new.run(["migration", migration])
        write_migration_content(migration)
      end
    end
  
    def write_migration_content(migration)
      copy_to_path = File.join(RAILS_ROOT, "db", "migrate")
      migration_filename = Dir.entries(copy_to_path).collect do |file|
        number, *name = file.split("_")
        file if name.join("_") == "#{migration}.rb"
      end.compact.first
      migration_file = File.join(copy_to_path, migration_filename)
      File.open(migration_file, "wb") do |f| 
        f.write(File.read(migration_source_file(migration)))
      end
    end
    
    def migration_source_file(migration)
      File.join(File.dirname(__FILE__), "../db", "migrate", "#{migration}.rb")
    end
  end
end 
