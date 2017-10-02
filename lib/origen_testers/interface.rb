require 'active_support/concern'

module OrigenTesters
  # Include this module in any class you define as a test interface
  module Interface
    extend ActiveSupport::Concern

    included do
      Origen.add_interface(self)
    end

    (ATP::AST::Builder::CONDITION_KEYS + [:group, :bin, :pass, :fail, :test, :log, :volatile, :sub_test]).each do |method|
      define_method method do |*args, &block|
        flow.send(method, *args, &block)
      end
    end

    class PatternArray < ::Array
      def <<(pat)
        push(pat)
      end

      # Override the array push method to capture the pattern under the new API, but
      # maintain the old one where a pattern reference was just pushed to the
      # referenced_patterns array
      def push(pat)
        Origen.interface.record_pattern_reference(pat)
      end
    end

    def self.with_resources_mode
      orig = @resources_mode
      @resources_mode = true
      yield
      @resources_mode = orig
    end

    def self.resources_mode?
      !!@resources_mode
    end

    def self.write=(val)
      @write = val
    end

    def self.write?
      !!@write
    end

    def write?
      OrigenTesters::Interface.write?
    end

    # Set to :enabled to have the current flow wrapped by an enable flow variable
    # that is enabled by default (top-level flow has to disable modules it doesn't want).
    #
    # Set to :disabled to have the opposite, where the top-level flow has to enable all
    # modules.
    #
    # Set to nil to have no wrapping. While this is the default, setting this to nil will
    # override any setting of the attribute of the same name that has been set at
    # tester-level by the target.
    def add_flow_enable=(value)
      return unless flow.respond_to?(:add_flow_enable=)
      if value
        if value == :enable || value == :enabled
          flow.add_flow_enable = :enabled
        elsif value == :disable || value == :disabled
          flow.add_flow_enable = :disabled
        else
          fail "Unknown add_flow_enable value, #{value}, must be :enabled or :disabled"
        end
      else
        flow.add_flow_enable = nil
      end
    end

    # This identifier will be used to make labels and other references unique to the
    # current application. This will help to avoid name duplication if a program is
    # comprised of many modules generated by Origen.
    #
    # Override in the application interface to customize, by default the identifier
    # will be Origen.config.initials
    def app_identifier
      Origen.config.initials || 'Anon App'
    end

    def close(options = {})
      sheet_generators.each do |generator|
        generator.close(options)
      end
    end

    # Compile a template file
    def compile(file, options = {})
      return unless write?
      # Any options passed in from an interface will be passed to the compiler and to
      # the templates being compiled
      options[:initial_options] = options
      Origen.file_handler.preserve_state do
        begin
          file = Origen.file_handler.clean_path_to_template(file)
          Origen.generator.compile_file_or_directory(file, options)
        rescue
          file = Origen.file_handler.clean_path_to(file)
          Origen.generator.compile_file_or_directory(file, options)
        end
      end
    end

    def import(file, options = {})
      # Attach the import request to the first generator, when it imports
      # it any generated resources will automatically find their way to the
      # correct generator/collection
      generator = flow || sheet_generators.first
      generator.import(file, options)
    end

    def render(file, options = {})
      flow.render(file, options)
    end

    def write_files(options = {})
      sheet_generators.each do |generator|
        generator.finalize(options)
      end
      sheet_generators.each do |generator|
        generator.write_to_file(options) if generator.to_be_written?
      end
      clean_referenced_patterns
      flow.save_program
    end

    def on_program_completion(options = {})
      reset_globals
      @@pattern_references = {}
      @@referenced_patterns = nil
    end

    # A secondary pattern is one where the pattern has been created by Origen as an output from
    # generating another pattern (a primary pattern). For example, on V93K anytime a tester
    # handshake is done, the pattern will be split into separate components, such as
    # meas_bgap.avc (the primary pattern) and meas_bgap_part1.avc (a secondary pattern).
    #
    # Any such secondary pattern references should be pushed to this array, rather than the
    # referenced_patterns array.
    # By using the dedicated secondary array, the pattern will not appear in the referenced.list
    # file so that Origen is not asked to generate it (since it will be created naturally from
    # the primary pattern reference).
    # However if the ATE requires a reference to the pattern (e.g. the V93K pattern master file),
    # then it will be included in the relevant ATE files.
    def record_pattern_reference(name, options = {})
      if name.is_a?(String) || name.is_a?(Symbol)
        name = name.to_s
      else
        fail "Pattern name must be a string or a symbol, not a #{name.class}"
      end
      # Help out the user and force any multi-part patterns to :ate type
      unless options[:type]
        if name.sub(/\..*/, '') =~ /part\d+$/
          options[:type] = :ate
        end
      end
      unless options[:type] == :origen
        # Inform the current generator that it has a new pattern reference to handle
        if respond_to?(:pattern_reference_recorded)
          pattern_reference_recorded(name, options)
        end
      end
      base = options[:subroutine] ? pattern_references[:subroutine] : pattern_references[:main]
      case options[:type]
      when :origen
        base[:origen] << name
      when :ate
        base[:ate] << name
      when nil
        base[:all] << name
      else
        fail "Unknown pattern reference type, #{options[:type]}, valid values are :origen or :ate"
      end
      nil
    end

    def pattern_references
      @@pattern_references ||= {}
      @@pattern_references[pattern_references_name] ||= {
        main:       {
          all:    [],
          origen: [],
          ate:    []
        },
        subroutine: {
          all:    [],
          origen: [],
          ate:    []
        }
      }
    end

    def all_pattern_references
      pattern_references
      @@pattern_references
    end

    def pattern_references_name=(name)
      @pattern_references_name = name
    end

    def pattern_references_name
      @pattern_references_name || 'global'
    end

    # @deprecated Use record_pattern_reference instead
    #
    # All generators should push to this array whenever they reference a pattern
    # so that it is captured in the pattern list, e.g.
    #   Origen.interface.referenced_patterns << pattern
    #
    # If the ATE platform also has a pattern list, e.g. the pattern master file on V93K,
    # then this will also be updated.
    # Duplicates will be automatically eliminated, so no duplicate checking should be
    # performed on the application side.
    def referenced_patterns
      @@referenced_patterns ||= PatternArray.new
    end

    # Remove duplicates and file extensions from the referenced pattern lists
    def clean_referenced_patterns
      refs = [:referenced_patterns]
      # refs << :referenced_subroutine_patterns if Origen.tester.v93k?
      refs.each do |ref|
        var = send(ref)
        var = var.uniq.map do |pat|
          pat = pat.sub(/\..*/, '')
          pat unless pat =~ /_part\d+$/
        end.uniq.compact
        singleton_class.class_variable_set("@@#{ref}", var)
      end
    end

    # Add a comment line into the buffer
    def comment(text)
      comments << text
    end

    def comments
      @@comments ||= []
    end

    def discard_comments
      @@comments = nil
    end

    # Returns the buffered description comments and clears the buffer
    def consume_comments
      c = comments
      discard_comments
      c
    end

    def top_level_flow
      @@top_level_flow ||= nil
    end
    alias_method :top_level_flow_filename, :top_level_flow

    def flow_generator
      flow
    end

    def set_top_level_flow
      @@top_level_flow = flow_generator.output_file
    end

    def clear_top_level_flow
      @@top_level_flow = nil
    end

    # A storage Hash that all generators can push comment descriptions
    # into when generating.
    # At the end of a generation run this will contain all descriptions
    # for all flows that were just created.
    #
    # Access via Origen.interface.descriptions
    def descriptions
      @@descriptions ||= Parser::DescriptionLookup.new
    end

    # Any tests generated within the given block will be generated in resources mode.
    # Generally this means that all resources for a given test will be generated but
    # flow entries will be inhibited.
    def resources_mode
      OrigenTesters::Interface.with_resources_mode do
        yield
      end
    end
    alias_method :with_resources_mode, :resources_mode

    def resources_mode?
      OrigenTesters::Interface.resources_mode?
    end

    def identity_map # :nodoc:
      @@identity_map ||= ::OrigenTesters::Generator::IdentityMap.new
    end

    def platform
      # This branch to support the ProgramGenerators module where the generator
      # is included into an interface instance and not the class
      if singleton_class.const_defined? :PLATFORM
        singleton_class::PLATFORM
      else
        self.class::PLATFORM
      end
    end

    module ClassMethods
      # Returns true if the interface class supports the
      # given tester instance
      def supports?(tester_instance)
        tester_instance.class == self::PLATFORM
      end
    end
  end
end
