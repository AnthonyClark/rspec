require 'rspec/support/caller_filter'
require 'rspec/support/warnings'

require 'rspec/matchers'
require 'rspec/expectations/expectation_target'
require 'rspec/matchers/configuration'
require 'rspec/expectations/fail_with'
require 'rspec/expectations/errors'
require 'rspec/expectations/handler'
require 'rspec/expectations/version'
require 'rspec/expectations/diff_presenter'

module RSpec
  # RSpec::Expectations adds two instance methods to every object:
  #
  #     should(matcher=nil)
  #     should_not(matcher=nil)
  #
  # Both methods take an optional matcher object (See
  # [RSpec::Matchers](../RSpec/Matchers)).  When `should` is invoked with a
  # matcher, it turns around and calls `matcher.matches?(self)`.  For example,
  # in the expression:
  #
  #     order.total.should eq(Money.new(5.55, :USD))
  #
  # the `should` method invokes the equivalent of `eq.matches?(order.total)`. If
  # `matches?` returns true, the expectation is met and execution continues. If
  # `false`, then the spec fails with the message returned by
  # `eq.failure_message_for_should`.
  #
  # Given the expression:
  #
  #     order.entries.should_not include(entry)
  #
  # the `should_not` method invokes the equivalent of
  # `include.matches?(order.entries)`, but it interprets `false` as success, and
  # `true` as a failure, using the message generated by
  # `eq.failure_message_for_should_not`.
  #
  # rspec-expectations ships with a standard set of useful matchers, and writing
  # your own matchers is quite simple.
  #
  # See [RSpec::Matchers](../RSpec/Matchers) for more information about the
  # built-in matchers that ship with rspec-expectations, and how to write your
  # own custom matchers.
  module Expectations

    # @api private
    KERNEL_METHOD_METHOD = ::Kernel.instance_method(:method)

    # @api private
    #
    # Used internally to get a method handle for a particular object
    # and method name.
    #
    # Includes handling for a few special cases:
    #
    #   - Objects that redefine #method (e.g. an HTTPRequest struct)
    #   - BasicObject subclasses that mixin a Kernel dup (e.g. SimpleDelegator)
    if RUBY_VERSION.to_i >= 2
      def self.method_handle_for(object, method_name)
        KERNEL_METHOD_METHOD.bind(object).call(method_name)
      end
    else
      def self.method_handle_for(object, method_name)
        if ::Kernel === object
          KERNEL_METHOD_METHOD.bind(object).call(method_name)
        else
          object.method(method_name)
        end
      end
    end
  end
end
