require 'rails/generators/base'

module MyZipcodeGem
  class Base < Rails::Generators::Base #:nodoc:
    # def self.source_root
    #   @_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'nifty', generator_name, 'templates'))
    #   puts ">>> @_source_root: [#{@_source_root}]"
    #   @_source_root
    # end

    def self.banner
      "rails generate my_zipcode_gem:#{generator_name} #{self.arguments.map{ |a| a.usage }.join(' ')} [options]"
    end

    private

      def add_gem(name, options = {})
        gemfile_content = File.read(destination_path("Gemfile"))
        File.open(destination_path("Gemfile"), 'a') { |f| f.write("\n") } unless gemfile_content =~ /\n\Z/
        gem name, options unless gemfile_content.include? name
      end

      def print_usage
        self.class.help(Thor::Base.shell.new)
        exit
      end

      def destination_path(path)
        File.join(destination_root, path)
      end

  end
end
