# frozen_string_literal: true

module Funcmlcli
  class RenderAll
    def initialize(options)
      @options = options
      
      _create_files_index
      _create_merged_mutations
    end

    def render!
      @files.each do |file|
        _save_or_display(file, _mutate(file))
      end
    end

    def _save_or_display(file, mutated_struct)
      if @options[:output_stdout]
        _display(file, mutated_struct) 
        return true
      end

      _save(file, mutated_struct)
    end

    def _display(file, mutated_struct)
      puts "##{file}"
      puts mutated_struct.deep_stringify_keys.to_yaml if @options[:output_format].match?(/(yaml)|(yml)/)
      puts mutated_struct.deep_stringify_keys.to_json if @options[:output_format].eql?("json")
    end

    def _save(file, mutated_struct)
      Dir.mkdir(@options[:output_directory]) unless File.exists?(@options[:output_directory])

      file_name = "#{@options[:output_directory]}/#{File.basename(file, ".*")}.#{@options[:output_format]}"

      File.open(file_name, "w+") do |f|
        f.write(mutated_struct.deep_stringify_keys.to_yaml) if @options[:output_format].match?(/(yaml)|(yml)/)
        f.write(mutated_struct.deep_stringify_keys.to_json) if @options[:output_format].eql?("json")
      end
    end

    def _mutate(file)
      struct = nil
      File.read(file).then do |file_data|
        begin
          struct = YAML.safe_load(file_data)
            .deep_symbolize_keys
            .mutate(@merged_mutations)
        rescue
          struct = JSON.parse(file_data, symbolize_keys: true)
            .mutate(@merged_mutations)
        end
      end

      return struct
    end

    def _create_files_index
      @files = @options[:extension_filter].map do |ext|
        if @options[:recursive]
          Dir.glob(@options.fetch(:directory) + "/**/*.#{ext}")
        else
          Dir.glob(@options.fetch(:directory) + "/*.#{ext}")
        end
      end.flatten
    end

    # _create_merged_mutations merges different mutation files into a single
    # mutation hash, either json or yaml.
    def _create_merged_mutations
      raise StandardError, "no mutation file provided" if @options[:mutation_files].count.zero?
      @merged_mutations = @options[:mutation_files].map do |mutation_file|
        File.read(mutation_file).then do |mf_data|
          begin
            YAML.safe_load(mf_data)
          rescue
            JSON.parse(mf_data)
          end
        end
      end.reduce(:merge!)
        .deep_symbolize_keys
    end
  end
end