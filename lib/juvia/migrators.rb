module Juvia
  module Migrators
    PLATFORMS = %w(word_press)

    PLATFORMS.each do |p|
      require "juvia/migrators/#{p}"
    end

    def self.process(site_id, migrator, dbname, user, host='localhost', options={})
      migrator_class = migrator.downcase.gsub(/\s/, '_')
      raise "Not a valid import type: #{migrator_class}" unless PLATFORMS.any?{ |p| p == migrator_class }

      Juvia::Migrators.const_get(migrator_class.camelize).send(:process, site_id, dbname, user, host, options)
    end
  end
end
