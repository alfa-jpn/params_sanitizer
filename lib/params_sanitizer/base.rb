module ParamsSanitizer
  require 'params_sanitizer/sanitizers/accept_value'

  class Base
    include ParamsSanitizer::Sanitizers::AcceptValue

    # Check a duplicated definition rule of parameter.
    #
    # @api for sanitizers exclusive use.
    # @param key [String] key of parameter.
    # @raise [ArgumentError] if duplicate the rule.
    def self.check_duplicated_definition!(key)
      string_key = key.to_s
      definitions.each_value do |rules|
        rules.each_key do |definition_key|
          if definition_key == string_key
            raise ArgumentError, 'already define the ruel for #{key}!!'
          end
        end
      end
    end

    # callback after inherited.
    #
    # @api
    def self.inherited(child)
      child.instance_variable_set(:@definitions, Hash.new)
    end

    # Get a list of permit keys.
    # @note Keys passed strong parameter.(ActionController::Parameters.permit method.)
    #
    # @example
    #   def self.permit_filter
    #     [:user_name, :user_email, :user_age]
    #   end
    #
    # @return [Array or Hash] a list of keys.
    # @abstract Define after inheritance.
    # @raise [ArgumentError] if not abstract.
    def self.permit_filter
      raise NoMethodError, 'Not define `self.permit_filter`. '
    end

    # Sanitize parameters.
    #
    # @example
    #   # if sent next params.
    #   # {
    #   #   user: { name: 'hoge', email: 'fuga'  }
    #   # }
    #   SanitizerClass.sanitize(params, :user)
    #
    #   # if sent next params.
    #   # { name: 'hoge', email: 'fuga' }
    #   SanitizerClass.sanitize(params)
    #
    # @param params [ActiveController::Parameters] parameter of Action.
    # @param key    [String] key of parameter. (if params `{user:{name:'hoge', email:'fuga'}}` then :user)
    # @raise [ActionController::ParameterMissing] if nothing key.
    def self.sanitize(params, key = nil)
      new.sanitize_params (key ? params.require(key) : params).permit(permit_filter)
    end

    # Sanitize params bu definition rules.
    #
    # @api mustn't call from out this class.
    # @param parmas[ActionController::Parameter] parameter,
    # @return [Hash] sanitizer hash of params.(Hash keys are symbol)
    def sanitize_params(params)
      sanitized = params.to_hash

      self.class.definitions.each do |key, rules|
        send("sanitize_#{key}!", sanitized, rules)
      end

      sanitized.symbolize_keys
    end

    # define class method accessor.
    class << self
      attr_reader :definitions
    end
  end
end
