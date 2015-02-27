require 'active_record'

module Aroi
  module Instrumentation

    def self.extended_active_record?
      !!@canvas_statsd_extended_active_record
    end

    def self.extended_active_record!
      @canvas_statsd_extended_active_record = true
    end

    def self.instrument_creation!
      ::ActiveRecord::Base.send(:include, Aroi::Instrumentation::ActiveRecord)
    end

    module ActiveRecord

      def self.included(klass)
        klass.class_eval do

          unless Aroi::Instrumentation.extended_active_record?
            self.singleton_class.send(:alias_method, :allocate_in_block, :allocate)
            def klass.allocate
              ActiveSupport::Notifications.instrument('instance.active_record', name: self.base_class.name) do
                allocate_in_block
              end
            end

            alias_method :initialize_in_block, :initialize
            def initialize(*args, &block)
              ActiveSupport::Notifications.instrument('instance.active_record', name: self.class.name) do
                initialize_in_block(*args, &block)
              end
            end

            Aroi::Instrumentation.extended_active_record!
          end

        end
      end

    end
  end
end
