require 'socket'
require 'json'
require 'logging'
require 'cucumber/wire_support/connection'
require 'cucumber/wire_support/wire_packet'
require 'cucumber/wire_support/wire_exception'
require 'cucumber/wire_support/wire_step_definition'

module Cucumber
  module WireSupport
    
    # The wire-protocol (lanugage independent) implementation of the programming language API.
    class WireLanguage
      include LanguageSupport::LanguageMethods
      
      def load_code_file(wire_file)
        log.debug wire_file
        
        config = YAML.load_file(wire_file)
        @connections << Connection.new(config)
      end
      
      def step_matches(step_name, formatted_step_name)
        @connections.map{ |remote| remote.step_matches(step_name, formatted_step_name)}.flatten
      end
      
      def initialize(step_mother)
        @connections = []
      end
      
      def alias_adverbs(adverbs)
      end
      
      protected
      
      def begin_scenario
      end
      
      def end_scenario
      end
      
      private
      
      def log
        Logging::Logger[self]
      end      
      
      def step_definitions
        @step_definitions ||= {}
      end
    end
  end
end

logfile = File.expand_path(File.dirname(__FILE__) + '/../../../cucumber.log')
Logging::Logger[Cucumber::WireSupport].add_appenders(
  Logging::Appenders::File.new(logfile)
)
Logging::Logger[Cucumber::WireSupport].level = :debug