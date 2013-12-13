module ParamsSanitizer::Sanitizers
  module RejectValue

    private

    # Sanitize a destructive params.
    # @note destructive method for params.
    #
    # @param params [Hash] parameters. (will be destructed by this method.)
    # @param rules  [Hash] rules of reject_value.
    def sanitize_reject_value!(params, rules)
      rules.each do |key, rule|
        if params.has_key?(key)
          params[key] = check_reject_value(params[key], rule[:default_value], rule[:reject_values])
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
    # @param reject_values  [Array]  admitted values.
    # @return [Object] value or default_value.
    def check_reject_value(value, default_value, reject_values)
      if reject_values.include?(value)
        default_value
      else
        value
      end
    end

    module SanitizerMethods
      # Define rule of reject value.
      #
      # @example
      #   reject_value(:user_name, nil, ['admin','root'])
      #
      # @param key           [String]        key of parameter.
      # @param default_value [Object]        default values when input not addmitted value.
      # @param reject_values [Array<Object>] reject values.
      def reject_value(key, default_value, reject_values)
        check_duplicated_definition!(key)
        definitions[:reject_value] ||= Hash.new
        definitions[:reject_value][key.to_s] = { default_value: default_value, reject_values: reject_values }
      end
    end


    def self.included(mixin)
      mixin.extend SanitizerMethods
    end
  end
end
