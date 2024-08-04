# frozen_string_literal: true
require "fileutils"

module Funcmlcli
  include Funcml

  class Render
    def initialize(path, options)
      @path = path
      @options = options

      @content = File.read(@path).then do |file_content|
        begin
          YAML.safe_load(file_content).deep_symbolize_keys
        rescue
          JSON.parse(file_content, symbolize_names: true)
        end
      end

      if options.fetch(:mutation_files, nil).nil?
        @mutations = @content
      else
        @mutations = {}
        options.fetch(:mutation_files).each do |mutation_file|
          File.read(mutation_file).then do |mutation_content|
            begin
              @mutations = @mutations.merge(YAML.safe_load(mutation_content).deep_symbolize_keys)
            rescue
              @mutations = @mutations.merge(JSON.parse(mutation_content, symbolize_names: true))
            end
          end
        end
      end
    end

    def render!
      result = @content.mutate(@mutations)
      if ["yaml", "yml"].include?(@options[:output_format])
        marshal = result.deep_stringify_keys.to_yaml
      elsif @options[:output_format].eql?("json")
        marshal = result.to_json
      else
        raise StandardError, "output-format must be yaml|yml|json"
      end

      if @options[:output_stdout]
        puts marshal
      end

      unless @options[:output_directory].eql?("false")
        dest_path = "#{@options[:output_directory]}/#{File.dirname(@path)}"
        FileUtils.mkdir_p(dest_path)
        File.open("%s/%s.%s" % [dest_path, File.basename(@path), @options[:output_format]], "w+") do |f|
          f.write(marshal)
        end
      end
    end
  end
end