module ParamsSanitizer::Sanitizers
  module AcceptRegex

    private

    # Sanitize a destructive params.
    # @note destructive method for params.
    #
    # @param params [Hash] parameters. (will be destructed by this method.)
    # @param rules  [Hash] rules of accept_regex.
    def sanitize_accept_regex!(params, rules)
      rules.each do |key, rule|
        if params.has_key?(key)
          params[key] = check_accept_regex(params[key], rule[:default_value], rule[:regex])
        else
          params[key] = rule[:default_value]
        end
      end
    end

    # Check whether a value is admitted regex.
    # @note return a default value when value is not admitted regex.
    #
    # @param value          [Object]  value
    # @param default_value  [Object]  default_value
    # @param regex          [Regexp] accept when regex match.
    # @return [Object] value or default_value.
    def check_accept_regex(value, default_value, regex)
      if regex.match(value)
        value
      else
        default_value
      end
    end

    module SanitizerMethods
      # Define rule of accept regex.
      #
      # @param key           [String] key of parameter.
      # @param default_value [Object] default values when input not addmitted value.
      # @param regex         [Regexp] accept when regex match.
      def accept_regex(key, default_value, regex)
        check_duplicated_definition!(key)
        definitions[:accept_regex] ||= Hash.new
        definitions[:accept_regex][key.to_s] = { default_value: default_value, regex: regex }
      end
    end

    def self.included(mixin)
      mixin.extend SanitizerMethods
    end
  end
end
