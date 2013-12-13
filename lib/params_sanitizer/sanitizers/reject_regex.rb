module ParamsSanitizer::Sanitizers
  module RejectRegex

    private

    # Sanitize a destructive params.
    # @note destructive method for params.
    #
    # @param params [Hash] parameters. (will be destructed by this method.)
    # @param rules  [Hash] rules of reject_regex.
    def sanitize_reject_regex!(params, rules)
      rules.each do |key, rule|
        if params.has_key?(key)
          params[key] = check_reject_regex(params[key], rule[:default_value], rule[:regex])
        else
          params[key] = rule[:default_value]
        end
      end
    end

    # Check whether a value is admitted regex.
    # @note return a default value when value is not admitted regex.
    #
    # @param value         [Object] value
    # @param default_value [Object] default_value
    # @param regex         [Regexp] reject when regex match.
    # @return [Object] value or default_value.
    def check_reject_regex(value, default_value, regex)
      if regex.match(value)
        default_value
      else
        value
      end
    end

    module SanitizerMethods
      # Define rule of reject regex.
      #
      # @example
      #   reject_regex(:number, 0, /^\w$/)
      #
      # @param key           [String] key of parameter.
      # @param default_value [Object] default values when input not addmitted value.
      # @param regex         [Regexp] reject when regex match.
      def reject_regex(key, default_value, regex)
        check_duplicated_definition!(key)
        definitions[:reject_regex] ||= Hash.new
        definitions[:reject_regex][key.to_s] = { default_value: default_value, regex: regex }
      end
    end

    def self.included(mixin)
      mixin.extend SanitizerMethods
    end
  end
end
