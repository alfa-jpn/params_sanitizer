module ParamsSanitizer::Sanitizers
  module AcceptValue

    private

    # Sanitize a destructive params.
    # @note destructive method for params.
    #
    # @param params [Hash] parameters. (will be destructed by this method.)
    # @param rules  [Hash] rules of accept_value.
    def sanitize_accept_value!(params, rules)
      rules.each do |key, rule|
        if params.has_key?(key)
          params[key] = check_accept_value(params[key], rule[:default_value], rule[:accept_values])
        else
          params[key] = rule[:default_value]
        end
      end
    end

    # Check whether a value is admitted.
    # @note return a default value when value is not admitted.
    #
    # @param value          [Object] value
    # @param default_value  [Object] default_value
    # @param accept_values  [Array]  admitted values.
    # @return [Object] value or default_value.
    def check_accept_value(value, default_value, accept_values)
      if accept_values.include?(value)
        value
      else
        default_value
      end
    end

    module SanitizerMethods
      # Define rule of accept value.
      #
      # @param key           [String]        key of parameter.
      # @param default_value [Object]        default values when input not addmitted value.
      # @param accept_values [Array<Object>] accept values.
      def accept_value(key, default_value, accept_values)
        check_duplicated_definition!(key)
        definitions[:accept_value] ||= Hash.new
        definitions[:accept_value][key.to_s] = { default_value: default_value, accept_values: accept_values }
      end
    end


    def self.included(mixin)
      mixin.extend SanitizerMethods
    end
  end
end